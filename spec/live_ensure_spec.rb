require 'live_ensure'

describe LiveEnsure do
  
  def stub_patron(body = 'success')
    @stub_response = stub('patron_response', :status => 200, :body => body)
    Patron::Session.any_instance.stub(:get).and_return(@stub_response)
  end
  
  def configure_live_ensure
    LiveEnsure.configure do |config|
      config.api_key = 'API_KEY'
      config.api_password = 'API_PASSWORD'
      config.api_agent_id = 'AGENT_ID'
    end
  end
    
  describe ".configure" do
    it "should let you set the api_key" do
      LiveEnsure.configure do |config|
        config.api_key = '1234'
      end

      LiveEnsure.configuration.api_key.should == '1234'
    end
    
    it "should let you set the api_password" do
      LiveEnsure.configure do |config|
        config.api_password = '1234'
      end

      LiveEnsure.configuration.api_password.should == '1234'
    end
    
    it "should let you set the agent_id" do
      LiveEnsure.configure do |config|
        config.api_agent_id = '1234'
      end

      LiveEnsure.configuration.api_agent_id.should == '1234'
    end
    
    it "should let you set the enabled config" do
      LiveEnsure.configure do |config|
        config.enabled = true
      end
      
      LiveEnsure.configuration.enabled = true
    end
  end
  
  describe ".request_launch" do
    before do
      configure_live_ensure
      stub_patron("4:5yqUulMdWhmXStCWVlJCKDjl:1\nhttps://app01.liveensure.com/live-identity\n")
    end
    
    subject { LiveEnsure.request_launch('test@stevedev.com') }

    it { should be_a LiveEnsure::SetupResponse }
    its(:launch_url) { should == "https://app01.liveensure.com/live-identity/launcher?sessionToken=5yqUulMdWhmXStCWVlJCKDjl" }
    its(:token) { should == '5yqUulMdWhmXStCWVlJCKDjl' }
  end
  
  describe ".session_status" do
    let(:session_status_response) { "3:a3SDQmP8PUf6jdGqqTN9O7D5:6\nmessage: SESSION_UNDETERMINED\nclient: light plus\nsession: unknown\ndeviceHash: f234eb56bcde603d85176e6c1c3db473\nknownDevice: true\nagent: quick\n" }
    let(:token) { '5yqUulMdWhmXStCWVlJCKDjl' }
    let(:base_url) { 'https://app01.liveensure.com/live-identity/' }
    
    before do
      configure_live_ensure
      stub_patron(session_status_response)
    end
    
    it "should raise an ArgumentError if the base_url is blank" do
      expect {
        LiveEnsure.session_status(token)
      }.to raise_error ArgumentError
    end
    
    it "should return a SessionStatusResponse object" do
      LiveEnsure.session_status(token, base_url).should be_a LiveEnsure::SessionStatusResponse
    end
  end

  describe ".get" do
    it "should create a new Patron session" do
      session = Patron::Session.new
      Patron::Session.should_receive(:new).and_return(session)
      
      stub_patron
      LiveEnsure.get('http://www.example.com')
    end
    
    it "should raise a ConnectionError if response status is >= 400" do
      stub_patron
      @stub_response.stub(:status => 404)
      expect {
        LiveEnsure.get('http://www.example.com')
      }.to raise_error LiveEnsure::ConnectionError
    end
  end
end