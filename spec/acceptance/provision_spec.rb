require 'spec/spec_helper'

describe 'thing' do
  include Rack::Test::Methods
  def app
    Croner
  end
  it 'should' do
    #post '/heroku/provision'
    get '/'
    p last_response
  end
end
