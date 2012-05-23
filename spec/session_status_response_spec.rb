require 'live_ensure/session_status_response'

describe LiveEnsure::SessionStatusResponse do
  let(:response) { "3:a3SDQmP8PUf6jdGqqTN9O7D5:6\nmessage: SESSION_UNDETERMINED\nclient: light plus\nsession: unknown\ndeviceHash: f234eb56bcde603d85176e6c1c3db473\nknownDevice: true\nagent: quick\n" }
  
  describe "attrs" do
    before do
      @response = LiveEnsure::SessionStatusResponse.new(response)
    end
    
    subject { @response }
    
    its(:message) { should == 'SESSION_UNDETERMINED' }
    its(:token) { should == 'a3SDQmP8PUf6jdGqqTN9O7D5' }
    its(:client) { should == 'light plus' }
    its(:session) { should == 'unknown' }
    its(:deviceHash) { should == 'f234eb56bcde603d85176e6c1c3db473' }
    its(:knownDevice) { should == 'true' }
    its(:agent) { should == 'quick' }
  end
  
  describe "#valid?" do
    it "should be valid if message == SUCCESS" do
      response_str = "3:a3SDQmP8PUf6jdGqqTN9O7D5:6\nmessage: SUCCESS\nclient: light plus\nsession: unknown\ndeviceHash: f234eb56bcde603d85176e6c1c3db473\nknownDevice: true\nagent: quick\n"
      response = LiveEnsure::SessionStatusResponse.new(response_str)
      response.should be_valid
    end
    
    it "should not be valid if message == FAILED" do
      response_str = "3:a3SDQmP8PUf6jdGqqTN9O7D5:6\nmessage: FAILED\nclient: light plus\nsession: unknown\ndeviceHash: f234eb56bcde603d85176e6c1c3db473\nknownDevice: true\nagent: quick\n"
      response = LiveEnsure::SessionStatusResponse.new(response_str)
      response.should_not be_valid
    end
    
    it "should not be valid if message == SESSION_UNDETERMINED" do
      response_str = "3:a3SDQmP8PUf6jdGqqTN9O7D5:6\nmessage: SESSION_UNDETERMINED\nclient: light plus\nsession: unknown\ndeviceHash: f234eb56bcde603d85176e6c1c3db473\nknownDevice: true\nagent: quick\n"
      response = LiveEnsure::SessionStatusResponse.new(response_str)
      response.should_not be_valid
    end
  end
  
  describe "#failed?" do
    it "should be failed if message == FAILED" do
      response_str = "3:a3SDQmP8PUf6jdGqqTN9O7D5:6\nmessage: FAILED\nclient: light plus\nsession: unknown\ndeviceHash: f234eb56bcde603d85176e6c1c3db473\nknownDevice: true\nagent: quick\n"
      response = LiveEnsure::SessionStatusResponse.new(response_str)
      response.should be_failed
    end
    
    it "should not be valid if message != FAILED" do
      response_str = "3:a3SDQmP8PUf6jdGqqTN9O7D5:6\nmessage: SUCCESS\nclient: light plus\nsession: unknown\ndeviceHash: f234eb56bcde603d85176e6c1c3db473\nknownDevice: true\nagent: quick\n"
      response = LiveEnsure::SessionStatusResponse.new(response_str)
      response.should_not be_failed
    end
  end
  
  describe "#undetermined?" do
    it "should be undetermined if message == SESSION_UNDETERMINED" do
      response_str = "3:a3SDQmP8PUf6jdGqqTN9O7D5:6\nmessage: SESSION_UNDETERMINED\nclient: light plus\nsession: unknown\ndeviceHash: f234eb56bcde603d85176e6c1c3db473\nknownDevice: true\nagent: quick\n"
      response = LiveEnsure::SessionStatusResponse.new(response_str)
      response.should be_undetermined
    end
    
    it "should not be undetermined if message != SESSION_UNDETERMINED" do
      response_str = "3:a3SDQmP8PUf6jdGqqTN9O7D5:6\nmessage: SUCCESS\nclient: light plus\nsession: unknown\ndeviceHash: f234eb56bcde603d85176e6c1c3db473\nknownDevice: true\nagent: quick\n"
      response = LiveEnsure::SessionStatusResponse.new(response_str)
      response.should_not be_undetermined
    end
  end
end