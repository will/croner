require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'sinatra/reloader'
require 'json'

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
    {:id => 'abc'}.to_json
  end
end
