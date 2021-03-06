require 'config/env'
require 'resque'
require 'resque_scheduler'
require 'jobs/run_app_cron'

if ENV['REDISTOGO_URL']
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
