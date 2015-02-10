require 'spec_helper'
describe "OmniAuth::ExpressoV3::AuthClient" do

  describe 'authenticate' do
    it 'should authenticate' do
      auth = OmniAuth::ExpressoV3::AuthClient.new
      auth_data = auth.authenticate("80129498572", "!sofia1004")
      expect(auth_data).not_to be(nil)
      expect(auth_data['keys']).not_to be(nil)
      data = auth.get_user_data
      expect(data['currentAccount']).not_to be(nil)
      expect(data['userContact']).not_to be(nil)

      File.open('spec/result.json', 'w+') do |f|
        f.write auth.last_raw_data
      end
      #data = auth.send('Tinebase.getRegistryData', nil)#, {'id' => '811540788f359c89384e616a58d8e75d46f160c6'})
      #puts data
    end
  end
end
