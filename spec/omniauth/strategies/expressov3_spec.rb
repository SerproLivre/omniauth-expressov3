require 'spec_helper'
require 'json'
describe "OmniAuth::Strategies::ExpressoV3" do

  before :all do
    display_label 'TESTING EXPRESSO V3 AUTHCLIENT'
    ENV['EXPRESSO_USERNAME'] ||= ask('Expresso Username: ')
    ENV['EXPRESSO_PASSWORD'] ||= ask("Expresso password for #{ENV['EXPRESSO_USERNAME']}: ") { |q| q.echo = false }
  end

  class ExpressoV3Provider < OmniAuth::Strategies::ExpressoV3; end

  let(:app) do
    Rack::Builder.new {
      use OmniAuth::Test::PhonySession
      use ExpressoV3Provider, :name => 'expressov3', :title => 'MyExpressoV3 Form'
      run lambda { |env| [404, {'Content-Type' => 'text/plain'}, [env.key?('omniauth.auth').to_s]] }
    }.to_app
  end

  let(:session) do
    last_request.env['rack.session']
  end

  it 'should add a camelization for itself' do
    expect(OmniAuth::Utils.camelize('expressov3')).to eq('ExpressoV3')
  end
  #
  describe '/auth/expressov3' do
    before(:each){ get '/auth/expressov3' }

    it 'should display a form' do
      last_response.status.should == 200
      last_response.body.should be_include("<form")
    end
  #
    it 'should have the callback as the action for the form' do
      last_response.body.should be_include("action='/auth/expressov3/callback'")
    end
  #
    it 'should have a text field for each of the fields' do
      last_response.body.scan('<input').size.should == 2
    end
    it 'should have a label of the form title' do
      last_response.body.scan('MyExpressoV3 Form').size.should > 1
    end
  end

  describe 'post /auth/expressov3/callback' do
    before(:each) do
      @auth = double(OmniAuth::ExpressoV3::AuthClient)
      @auth.stub(:authenticate)
      OmniAuth::ExpressoV3::AuthClient.stub(:new).and_return(@auth)
      @auth_failure = {}
    end

    context 'failure' do
      before(:each) do
        @auth.stub(:authenticate).and_return(false)
      end

      context "when username is not preset" do
        it 'should redirect to error page' do
          post('/auth/expressov3/callback', {})

          expect(last_response).to be_redirect
          expect(last_response.headers['Location']).to match(%r{missing_credentials})
        end
      end

      context "when username is empty" do
        it 'should redirect to error page' do
          post('/auth/expressov3/callback', {:username => ""})

          expect(last_response).to be_redirect
          expect(last_response.headers['Location']).to match(%r{missing_credentials})
        end
      end

      context "when username is present" do
        context "and password is not preset" do
          it 'should redirect to error page' do
            post('/auth/expressov3/callback', {:username => "ping"})

            expect(last_response).to be_redirect
            expect(last_response.headers['Location']).to match(%r{missing_credentials})
          end
        end

      context "and password is empty" do
        it 'should redirect to error page' do
          post('/auth/expressov3/callback', {:username => "ping", :password => ""})

          expect(last_response).to be_redirect
          expect(last_response.headers['Location']).to match(%r{missing_credentials})
        end
      end
    end

    context "when username and password are present" do
      context "and authenticate on Expresso server failed" do
        it 'should redirect to error page' do
          post('/auth/expressov3/callback', {:username => 'ping', :password => 'password'})

          expect(last_response).to be_redirect
          expect(last_response.headers['Location']).to match(%r{invalid_credentials})
        end
      end
    end

    context "and communication with ExpressoV3 server caused an exception" do
      before :each do
        @auth.stub(:authenticate).and_throw(Exception.new('connection_error'))
      end

      it 'should redirect to error page' do
        post('/auth/expressov3/callback', {:username => "ping", :password => "password"})

        expect(last_response).to be_redirect
        expect(last_response.headers['Location']).to match(%r{expressov3_error})
      end
    end
  end

  context 'success touching service' do

    before(:each) do
      OmniAuth::ExpressoV3::AuthClient.unstub(:new)
    end
    let(:auth_hash){ last_request.env['omniauth.auth'] }

    it 'should authenticate on expresso v3' do
      post('/auth/expressov3/callback', {:username => ENV['EXPRESSO_USERNAME'], :password => ENV['EXPRESSO_PASSWORD']})
      expect(auth_hash.provider).to eq('expressov3')
      expect(auth_hash.info.account_id).to eq('801294985')
      expect(auth_hash.info.username).to eq('80129498572')
      expect(auth_hash.info.email).to eq('abner.oliveira@serpro.gov.br')
    end
  end

    #
    context 'success' do
      let(:auth_hash){ last_request.env['omniauth.auth'] }

      let(:hash_result) {
        json_path = File.expand_path(File.dirname(__FILE__) + '../../../result.json')
        File.open(json_path) do |f|
          json = f.read
          return JSON.parse(json)
        end
      }

      before(:each) do
        @auth = double(OmniAuth::ExpressoV3::AuthClient)
        @auth.stub(:authenticate).and_return({})
        @auth.stub(:get_user_data).and_return({})
        OmniAuth::ExpressoV3::AuthClient.stub(:new).and_return(@auth)

      end

      it 'should not redirect to error page' do
        post('/auth/expressov3/callback', {:username => 'ping', :password => 'password'})
        expect(last_response).not_to be_redirect
      end

      it 'should map user info to Auth Hash' do
        @auth.stub(:get_user_data).and_return(hash_result)
        post('/auth/expressov3/callback', {:username => 'ping', :password => 'password'})
        expect(auth_hash.provider).to eq('expressov3')
        expect(auth_hash.info.account_id).to eq('111111111')
        expect(auth_hash.info.username).to eq('11111111111')
        expect(auth_hash.info.email).to eq('joao.ninguem@serpro.gov.br')
        expect(auth_hash.info.first_name).to eq('Joao')
        expect(auth_hash.info.last_name).to eq('Ninguem')
        expect(auth_hash.info.name).to eq('Joao Ninguem')
        expect(auth_hash.info.telephone).to eq('(71)1111-1111')
        expect(auth_hash.info.organization_unit).to eq('SUPDE/DESDR/DE5CT')
        expect(auth_hash.info.tine_key).to eq('tine_key')
        expect(auth_hash.info.json_key).to eq('json_key')
        expect(auth_hash.info.contact_id).to eq('contact_id')
      end
    end
  end
end
