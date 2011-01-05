require 'spec/spec_helper'
require 'jobs'

describe RunAppCron do
  it 'should be in the scans queue' do
    RunAppCron.instance_variable_get(:@queue).should == :runappcron
  end
end

describe RunAppCron, '.perform' do
end
