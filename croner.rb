require 'config/env'
require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'haml'

class Croner < Sinatra::Base
  configure(:development) do
    register Sinatra::Reloader
  end

  set :public, File.dirname(__FILE__) + '/public'

  use Rack::Auth::Basic do |username, password|
    (username == 'heroku' && password == 'b1EWrHYXE1R5J71D') ||
    (username == 'test')
  end unless ENV['RACK_ENV']=='test'

  get '/' do
    @apps = App.all
    haml :index
  end

  post '/heroku/resources' do
    body = JSON.parse request.body.string
    app = App.new body
    if app.save
      {:id => app.id}.to_json
    else
      status 500
    end
  end

  delete '/heroku/resources/:id' do
    begin
      doc = DB.get params['id']
      doc.destroy
    rescue RestClient::ResourceNotFound
      status 404
    end
  end
end
