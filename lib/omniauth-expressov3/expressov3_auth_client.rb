require 'recursive-open-struct'
module OmniAuth
  module ExpressoV3
    class AuthClient

      class MissingArgumentsError < Exception; end
      class AuthenticationError < Exception; end
      class ConnectionError < Exception; end

      SERVICE_URL =  "https://expressobr.serpro.gov.br"

       VALID_ADAPTER_CONFIGURATION_KEYS = [:service_url]

      def initialize(options={})
        service_url = options['service_url'] || SERVICE_URL
        @debug = options['debug'] || options[:debug]
        @json_tine = JSONRPCTineConnection.new service_url, @debug
      end

      def send(method_name, args={})
        @json_tine.send(method_name, args)
        @json_tine.result
      end

      def authenticate(username, password)
        validate_arguments(username, password)
        auth_params = {"username" => username,"password" => password}

        @json_tine.send 'Tinebase.login', auth_params

        # check if user is authenticated,  raises an authentication if not
        validate_login(@json_tine.result)
        #return user data
        build_struct @json_tine.result
      end

      def send method, args={}
          @json_tine.send method, args
          build_struct @json_tine.result
      end

      def get_user_data args={}
        #request to get user data
        @json_tine.send 'Tinebase.getAllRegistryData', args

        # hash with user data
        build_struct :keys => @json_tine.result['keys'],
            :currentAccount => @json_tine.result['Tinebase']['currentAccount'],
            :userContact    => @json_tine.result['Tinebase']['userContact'],
            :expressoAccount    => @json_tine.result['Expressomail']['accounts']['results'][0]
      end

      def last_raw_data
        @json_tine.last_body
      end

      def close
        @json_tine.close if @json_tine
      end
  protected
      def build_struct hash
        RecursiveOpenStruct.new hash,  :recurse_over_arrays => true
      end
      def validate_arguments(username, password)
        if username.nil? or password.nil?
          raise MissingArgumentsError.new('missing credentials arguments')
        end
        if "".eql?(username) or "".eql?(password)
          raise MissingArgumentsError.new('missing credentials arguments')
        end
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
end
