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
    begin
      DB.recreate! unless 0 == DB.info['update_seq']
    rescue RestClient::ResourceNotFound
      CouchRest.database!(DB.name)
    end
  end
end

