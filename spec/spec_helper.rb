require "codeclimate-test-reporter"
require  'highline/import'
require  'awesome_print'
CodeClimate::TestReporter.start

$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'rspec'
require 'rack/test'
require 'omniauth'
require 'omniauth-expressov3'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy

  OmniAuth.config.logger = Logger.new(File.expand_path('../omniauth.log', __FILE__))
end

def muted?
  @@mute
end

def mute!
  @@mute = true
end

def unmute!
  @@mute = false
end

@@mute = true

def display_label label
  return if muted?
  puts ''
  display_line
  if label
    puts label
    display_line
  end
end

def display_line
  puts '-' * HighLine::SystemExtensions.terminal_size[0] unless muted?
end

def p msg
  puts msg unless muted?
end

def puts_object object
  ap object unless muted?
end
