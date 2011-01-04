require 'env'
require 'sinatra'
require 'sinatra/reloader'
require 'couchrest'

if ENV['RACK_ENV'] == 'production'
  DB = CouchRest.database "http://withadoutheryraltionaper:yVF6gxqRqmsccBiawOcUraBs@will.cloudant.com/croner"
else
  DB = CouchRest.database! 'croner'
end

class Croner < Sinatra::Base
  configure(:development) do
    register Sinatra::Reloader
  end

  use Rack::Auth::Basic do |username, password|
    (username == 'heroku' && password == 'b1EWrHYXE1R5J71D') ||
    (username == 'test')
  end unless ENV['RACK_ENV']=='test'

  get '/' do
    "hello"
  end

  post '/heroku/resources' do
    body = JSON.parse request.body.string
    doc = DB.save_doc body
    {:id => doc['id']}.to_json
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
