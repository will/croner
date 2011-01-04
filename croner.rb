require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'sinatra/reloader'
require 'json'
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
    doc = DB.save_doc( {'params' => body} )

    {:id => doc['_id']}.to_json
  end
end
