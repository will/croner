require 'rubygems'
require 'bundler'
Bundler.setup
require 'json'
require 'couchrest'
require 'couchrest_model'

if ENV['RACK_ENV'] == 'production'
  DB = CouchRest.database "http://withadoutheryraltionaper:yVF6gxqRqmsccBiawOcUraBs@will.cloudant.com/croner"
else
  DB = CouchRest.database! 'croner'
end

require 'jobs'
require 'models/app'
