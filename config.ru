require 'config/env'
require 'croner'

app = Rack::Builder.new do
  use Rack::Auth::Basic do |username, password|
    (username == 'heroku' && password == 'b1EWrHYXE1R5J71D') ||
    (username == password && password == 'himitsu10')
  end unless ENV['RACK_ENV']=='test'

  map '/' do
    run Croner
  end
  map '/resque' do
    run Resque::Server.new
  end
end

run app
