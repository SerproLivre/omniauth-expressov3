require 'net/http'
require 'rubygems'
require 'json'
module OmniAuth
  module ExpressoV3
    #classe para fazer a conexão com o expresso3/tine20
    class JSONRPCTineConnection
      OUR_UNSAFE = /[^ _\.!~*'()a-zA-Z\d;\/?:@&=+$,{}\"-]/nm unless defined?(OUR_UNSAFE)
      @req = nil
      @uri = nil
      @host = nil
      @port = nil
      @json_return
      @json_key = nil
      @tine_key = nil
      @debug = false
      def initialize(uri, debug = false)
        @uri = URI.parse(uri)
        @host = @uri.host
        @port = @uri.port
        @debug = debug
      end

      def send(method, method_id, args=nil)
        @req = Net::HTTP::Post.new(@uri.request_uri, initheader = {'Content-Type'=>'application/json'})
        json_body = {:jsonrpc => '2.0', :method => method, :id => method_id}
        json_body.merge!({:params => args}) unless args.nil?
        @req.body = uri_escape_sanely( json_body.to_json )
        add_request_fields #headers e cookies
        http = Net::HTTP.new(@uri.host, @uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.start {|http| http.request(@req) }
        puts "Response #{response.code} #{response.message}: #{response.body}" if @debug
        @json_return = JSON.parse(response.body)
        unless @tine_key && @json_key
        @json_key = @json_return['result']['jsonKey'] if @json_return['result']
        @tine_key = response.get_fields('Set-Cookie').to_s.split(';')[0].split('=')[1]
        end
        puts "TINE_KEY: "+@tine_key if @tine_key and @debug
        puts "JSON_KEY: "+@json_key if @json_key and @debug
        return response, response.body
      end

      def last_json_object
        @json_return
      end

      def result
        keys.merge(@json_return['result'])
      end

      def keys
        {
          'keys' => {'tine_key' => @tine_key, 'json_key' => @json_key}
        }
      end

      def close
        @req = nil
        @uri = nil
        @host = nil
        @port = nil
        @json_key = nil
        @tine_key = nil
      end

    protected
      def add_request_fields
        #headers sempre enviados
        @req.add_field 'User-Agent', 'Ruby JSON-RPC Client 2.0'
        @req.add_field 'Accept',
        #
        #
        'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
        @req.add_field 'Content-Type', 'application/json; charset=UTF-8'
        @req.add_field 'X-Tine20-Request-Type', 'JSON'
        #
        #header e cookie enviados pelo usuario logado
        @req.add_field 'X-Tine20-JsonKey', @json_key if @json_key
        @req.add_field 'Cookie', 'TINE20SESSID='+@tine_key if @tine_key
      end

      def uri_escape_sanely(str)
        URI.escape(str, OUR_UNSAFE).gsub('%5B', '[').gsub('%5D', ']') # Ruby's regexes are BRAIN-DEAD.
      end

    end
  end
end

# def type(msg)
#     sleep 1 #pausa para poder ler
#     puts msg
#     sleep 2 #pausa para observar os resultados
# end
#
#
# type "### Abrindo conexao com o servidor do expresso3/tine20"
# json_tine = JSONRPCTineConnection.new "https://expressov3.serpro.gov.br/index.php"
# #
# #
# #type "### Listando metodos do usuario nao logado ###"
# #response, body = json_tine.send nil, '1'
# #
# #
# type "### Efetuando login ###"
# #
# #
# auth_params = {"user" => 'CPF_AQUI',"password" => 'SENHA AQUI'}
# response, body = json_tine.send 'Tinebase.login', '2', auth_params
#
# #auth_params = {"user" => 'CPF_AQUI',"password" => 'SENHA_AQUI'}
# #response, body = json_tine.send 'Tinebase.authenticate', '1', auth_params
#
#
# #type "### Listando metodos do usuario logado ###"
# #response, body = json_tine.send nil, '1'
#
# #type "### Listando dados do usuario logado ###"
# #response, body = json_tine.send 'Tinebase.getRegistryData', '1'
# response, body = json_tine.send 'Tinebase.getAllRegistryData', '2'
# #raise json_tine.result['Expressomail'].keys.inspect
#
# @level = 0
#
# @parents = []
#
# def print_k(hash, f, level=0, parent='')
#   @parents << parent if level > 0
#   hash.keys.each do |k|
#     f.write("\t" * @level + '-' + k + "(" +  @parents.join('/') + ")" + "\n")
#     if(hash[k].respond_to?(:keys))
#       @level += 1
#       print_k(hash[k], f, @level, k)
#     end
#   end
#   @level -= 1 if(@level > 0)
#   @parents.delete(parent)
# end
#
# f = File.open('/tmp/st.txt', 'w+')
# print_k(json_tine.last_json_object,f)
# f.close
#
# body2 = {
#         :currentAccount => json_tine.result['Tinebase']['currentAccount'],
#         :userContact    => json_tine.result['Tinebase']['userContact']
#        }
#
#
# #type "### Pesquisando contatos ###"
# #response, body = json_tine.send 'Addressbook.searchContacts', '10'
# #
# #
# #type "### Carregando mensagens ###"
# #
#
# #params = {"filter"=>{"field"=>"flags","operator"=>"in","value"=>"\\Flagged"},
# #  "paging"=>{"sort"=>"received","dir"=>"DESC","start"=>0,"limit"=>5}}
# #response, body = json_tine.send 'Felamimail.searchMessages', '21', params
# #response, body = json_tine.send 'Felamimail.getRegistryData', '21', params
#
#
# File.open('/tmp/dados_abner.json', 'w+') do |f|
#   f.write body2
# end
#
# exit 0
#
# #type "### Listando metodos do usuario logado ###"
# #response, body = json_tine.send , '1'
