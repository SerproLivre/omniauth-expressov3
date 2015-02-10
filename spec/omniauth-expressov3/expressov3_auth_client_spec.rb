require 'spec_helper'
describe "OmniAuth::ExpressoV3::AuthClient" do

  describe 'authenticate' do
    it 'should authenticate' do
      auth = OmniAuth::ExpressoV3::AuthClient.new
      #adaptor.connection.should_receive(:open).and_yield(adaptor.connection)
      #adaptor.connection.should_receive(:search).with(args).and_return([rs])
      #adaptor.connection.should_receive(:bind).with({:username => 'new dn', :password => args[:password], :method => :simple}).and_return(true)
      user_data = auth.authenticate(ENV['EXPRESSO_USERNAME'], ENV['EXPRESSO_PASSWORD'])
      expect(user_data).not_to be(nil)
      expect(user_data['keys']).not_to be(nil)
      expect(user_data['currentAccount']).not_to be(nil)
      expect(user_data['userContact']).not_to be(nil)
    end
  end
end
