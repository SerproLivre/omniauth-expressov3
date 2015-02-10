require 'spec_helper'
describe "OmniAuth::ExpressoV3::AuthClient" do

  describe 'authenticate' do
    it 'should authenticate' do
      auth = OmniAuth::ExpressoV3::AuthClient.new('debug' => true)
      auth_data = auth.authenticate("80129498572", "!sofia1004")
      expect(auth_data).not_to be(nil)
      expect(auth_data['keys']).not_to be(nil)
      puts auth_data.inspect

      data = auth.get_user_data
      puts data.inspect
      #expect(data['currentAccount']).not_to be(nil)
      #expect(data['userContact']).not_to be(nil)


      data = auth.send('Felamimail.getRegistryData', nil)#, {'id' => '811540788f359c89384e616a58d8e75d46f160c6'})
      puts data
    end
  end
end
