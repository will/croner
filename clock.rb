require 'env'
require 'clockwork'
require 'jobs'
include Clockwork

every 10.seconds, 'hourly' do
  Resque.enqueue HourlyScan
end
