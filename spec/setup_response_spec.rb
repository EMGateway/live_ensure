$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'live_ensure/setup_response'

describe LiveEnsure::SetupResponse do
  let(:input) { "4:5yqUulMdWhmXStCWVlJCKDjl:1\nhttps://app01.liveensure.com/live-identity\n" }
  
  it "should accept the provided string" do
    response = LiveEnsure::SetupResponse.new(input)
  end
  
  describe "attrs" do
    before do
      @response = LiveEnsure::SetupResponse.new("4:Foo:1\nhttps://app01.liveensure.com/live-identity\n")
    end
    
    subject { @response }
    
    its(:launch_url) { should == "https://app01.liveensure.com/live-identity/launcher?sessionToken=Foo" }
    its(:token) { should == "Foo" }
    its(:code) { should == 4 }
    its(:base_url) { should == 'https://app01.liveensure.com/live-identity' }
  end
  
  describe "invalid input" do
    it "should throw an exeption if content of input is invalid" do
      expect { 
        LiveEnsure::SetupResponse.new("")
      }.to raise_error LiveEnsure::InvalidResponse
    end
  end
  
  describe "response codes" do
    describe "0" do
      it "should raise an AuthSessionError" do
        expect {
          LiveEnsure::SetupResponse.new("0:null:error_code_or_message")
        }.to raise_error LiveEnsure::AuthSessionError
      end
    end 
    
    describe "1" do
      before do
        response_string = "1:5yqUulMdWhmXStCWVlJCKDjl:successMessage\n"
        @response = LiveEnsure::SetupResponse.new(response_string)
      end
      
      it "should return the default URL" do
        @response.launch_url.should == "#{LiveEnsure::HOST}/launcher?sessionToken=5yqUulMdWhmXStCWVlJCKDjl"
      end
      
      it "should set the code to 1" do
        @response.code.should == 1
      end
    end
    
    describe "2" do
      it "should raise a ServiceDown exception" do
        expect {
          LiveEnsure::SetupResponse.new('2:errorToken:service_down_message')
        }.to raise_error LiveEnsure::ServiceDown
      end
    end
    
    describe "4" do
      before do
        @response = LiveEnsure::SetupResponse.new(input)
      end
      
      it "should return the supplied URL instead of the default" do
        @response.launch_url.should == 'https://app01.liveensure.com/live-identity/launcher?sessionToken=5yqUulMdWhmXStCWVlJCKDjl'
      end
      
      it "should set the code to 4" do
        @response.code.should == 4
      end
    end
  end
  
end