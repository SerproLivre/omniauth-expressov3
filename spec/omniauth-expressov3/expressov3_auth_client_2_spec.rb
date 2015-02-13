require 'spec_helper'
describe "OmniAuth::ExpressoV3::AuthClient" do

  before :all do
    display_label 'TESTING EXPRESSO V3 AUTHCLIENT'
    ENV['EXPRESSO_USERNAME'] ||= ask('Expresso Username: ')
    ENV['EXPRESSO_PASSWORD'] ||= ask("Expresso password for #{ENV['EXPRESSO_USERNAME']}: ") { |q| q.echo = false }
    #unmute!  - habilita os outputs de debug do test
  end

  describe 'authenticate' do
    it 'should authenticate' do
      auth = OmniAuth::ExpressoV3::AuthClient.new :debug => false
      auth_data = auth.authenticate(ENV['EXPRESSO_USERNAME'], ENV['EXPRESSO_PASSWORD'])
      expect(auth_data).not_to be(nil)

      expect(auth_data.keys).not_to be(nil)
      data = auth.get_user_data

      expect(data.currentAccount).not_to be(nil)
      expect(data.userContact).not_to be(nil)
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
              {field: "account_id", operator: "equals", value: @user_data.expressoAccount.id},
              {field: "globalname", operator: "equals", value: ""}

            ]
        }
        result = @auth.send("Expressomail.searchFolders", args)
        display_label "PRINTING FOLDERS"
        result.results.each do |folder|
          p "FOLDER: #{folder.id} - #{folder.globalname} (#{folder.cache_totalcount}) emails (#{folder.cache_unreadcount}) unread"
          p "FOLDER DATA: "
          puts_object folder
          display_line
        end
      end

      context "messages" do
        let(:inbox_folder) do
          args = {
            filter:
              [
                {field: "account_id", operator: "equals", value: @user_data.expressoAccount.id},
                {field: "globalname", operator: "equals", value: ""}

              ]
          }
          result = @auth.send("Expressomail.searchFolders", args)
          folder = result.results.first
        end
        it 'search Messages' do
          inbox_id = inbox_folder.id
          account_id = @user_data.expressoAccount.id
          args = {
            filter:
            [
              {
                condition: "OR",
                filters: [
                    {condition: "AND", filters: [{field: "query", operator: "contains", value: "", id: "ext-record-351"},
                      { field: "path", operator: "in",
                                value: ["/#{account_id}/#{inbox_id}"],
                                id: "ext-record-368"}],
                id: "ext-comp-1101", label: "Messages"}]}],
            paging:
                    {
                        sort: "received", dir: "DESC", start: 0, limit: 5
                    }
          }
          response = @auth.send("Expressomail.searchMessages", args)

          display_label  "LISTING LAST 5 MESSAGES"

          response.results.each do |msg|
            p "SUBJECT: #{msg.subject}"
            p "EMAIL DATA: "
            puts_object msg
            display_line
          end
        end
        it 'query for Expressomail.updateMessageCache' do
          args = {
             folderId: inbox_folder.id,
             time: 10
           }
          result = @auth.send("Expressomail.updateMessageCache", args)
          display_label "UPDATING MESSAGES CACHE"
          puts_object result
        end
      end
    end
  end
end
