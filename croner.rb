require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'

class Croner < Sinatra::Base
  get '/' do
    "hello"
  end
end
