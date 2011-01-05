require 'rubygems'
require 'bundler'
Bundler.setup
require 'json'
require 'couchrest'
require 'couchrest_model'

if ENV['COUCHDB_URL']
  DB = CouchRest.database ENV['COUCHDB_URL']
else
  DB = CouchRest.database! 'croner'
end

require 'jobs'
require 'models/app'
