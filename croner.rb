require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'sinatra/reloader'

class Croner < Sinatra::Base
  configure(:development) do
    register Sinatra::Reloader
  end

  get '/' do
    "hello"
  end

  post '/heroku/resources' do
    p params
  end
end
