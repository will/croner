ENV['RACK_ENV']='test'
require 'rack/test'
require 'croner'
require 'rspec'

RSpec.configure do |config|
  include Rack::Test::Methods
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

