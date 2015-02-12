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

  context 'explore tine api' do

    before :all do
      @auth = OmniAuth::ExpressoV3::AuthClient.new :debug => false
      #@auth.authenticate(ENV['EXPRESSO_USERNAME'], ENV['EXPRESSO_PASSWORD'])
      @auth_data = @auth.authenticate(ENV['EXPRESSO_USERNAME'], ENV['EXPRESSO_PASSWORD'])
      @user_data = @auth.get_user_data
    end

    after :all do
      @auth.close
    end

    context 'queries' do
      it 'search folders' do
        args = {
          filter:
            [
              {field: "account_id", operator: "equals", value: @user_data["expressoAccount"]["id"]},
              {field: "globalname", operator: "equals", value: ""}

            ]
        }
        result = @auth.send("Expressomail.searchFolders", args)
        puts "----------------------------------------------------------"
        puts "PRINTING FOLDERS"
        puts "----------------------------------------------------------"
        result['results'].each do |folder|
          puts "FOLDER: #{folder['id']} - #{folder['globalname']} (#{folder['cache_totalcount']}) emails (#{folder['cache_unreadcount']}) unread"
          puts "FOLDER DATA: #{folder.inspect}"
          puts "----------------------------------------------------------"
        end
      end
      it 'search Messages' do
        args = {
          filter:
          [
            {
              condition: "OR",
              filters: [
                  {condition: "AND", filters: [{field: "query", operator: "contains", value: "", id: "ext-record-351"},
                    { field: "path", operator: "in",
                              value: ["/4e3f366969900893e80664b9c745a254f451aacb/NGUzZjM2Njk2OTkwMDg5M2U4MDY2NGI5Yzc0NWEyNTRmNDUxYWFjYjtJTkJPWA2"],
                              id: "ext-record-368"}],
              id: "ext-comp-1101", label: "Messages"}]}],
          paging:
                  {
                      sort: "received", dir: "DESC", start: 0, limit: 5
                  }
        }
        result = @auth.send("Expressomail.searchMessages", args)
        puts "----------------------------------------------------------"
        puts "LSITING LAST 5 MESSAGES"
        puts "----------------------------------------------------------"
        (0..4).each do |i|
          puts "SUBJECT: #{result['results'][i]['subject']}"
          puts "EMAIL DATA: #{result['results'][i].inspect}"
          puts "----------------------------------------------------------"
        end
              end
      it 'query for Expressomail.updateMessageCache' do
        args = {
           folderId: 'NGUzZjM2Njk2OTkwMDg5M2U4MDY2NGI5Yzc0NWEyNTRmNDUxYWFjYjtJTkJPWA2',
           time: 10
         }
        result = @auth.send("Expressomail.updateMessageCache", args)
        puts "----------------------------------------------------------"
        puts "UPDATING MESSAGES CACHE"
        puts "----------------------------------------------------------"
        puts result
      end
    end
  end
end
