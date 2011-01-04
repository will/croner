require 'spec/spec_helper'

describe 'provisioning' do
  include Rack::Test::Methods
  def app
    Croner
  end

  def parsed
    JSON.parse last_response.body
  end

  it 'should return an id' do
    post '/heroku/resources'
    last_response.status.should == 200
    parsed.should have_key('id')
  end
end
