require File.expand_path("../jsonrpc_tine_connection", __FILE__)
require File.expand_path("../account_data", __FILE__)
require File.expand_path("../authentication_error", __FILE__)
module ExpressoV3Serpro
  class Authenticator

    @@URL_BASE =  "https://expressov3.serpro.gov.br/index.php"

    def initialize
      @json_tine = JSONRPCTineConnection.new "https://expressov3.serpro.gov.br/index.php", false
    end

    def authenticate(username, password)
      auth_params = {"user" => username,"password" => password}
      @json_tine.send 'Tinebase.login', '1', auth_params
      # check if user is authenticated,  raises an authentication if not
      validate_login(@json_tine.result)
      #return user data
      get_user_data
    end


  protected

    def get_user_data
      #request to get user data
      @json_tine.send 'Tinebase.getAllRegistryData', '2'
      #hash with user data
      { :currentAccount => @json_tine.result['Tinebase']['currentAccount'],
        :userContact    => @json_tine.result['Tinebase']['userContact']
      }
    end

    def validate_login(response_result)
      authenticated = false
      authentication_failure_msg = ""
      if response_result
        authenticated = response_result['success']
      end
      raise AuthenticationError.new(authentication_failure_msg) unless authenticated
    end
  end
end


