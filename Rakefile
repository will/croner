require 'config/env'
require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" do
  ENV['QUEUE'] = '*'
end

desc "Alias for resque:work"
task "jobs:work" => "resque:work"

