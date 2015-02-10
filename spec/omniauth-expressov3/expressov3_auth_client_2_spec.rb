require 'spec_helper'
describe "OmniAuth::ExpressoV3::AuthClient" do

  describe 'authenticate' do
    it 'should authenticate' do
      auth = OmniAuth::ExpressoV3::AuthClient.new
      auth_data = auth.authenticate(ENV['EXPRESSO_USERNAME'], ENV['EXPRESSO_PASSWORD'])
      expect(auth_data).not_to be(nil)
      expect(auth_data['keys']).not_to be(nil)
      data = auth.get_user_data

      expect(data['currentAccount']).not_to be(nil)
      expect(data['userContact']).not_to be(nil)
      auth.close
    end
  end
end
