ENV['RACK_ENV']='test'
require 'rack/test'
require 'croner'
require 'rspec'
require 'webmock'

RSpec.configure do |config|
  include Rack::Test::Methods
  include WebMock::API
  WebMock.disable_net_connect!(:allow_localhost => true)
  def app
    Croner
  end
  def parsed
    JSON.parse last_response.body
  end

  config.before(:each) do
    DB.recreate!
  end

  config.after(:each) do
    Redis.new.flushall
  end
end

