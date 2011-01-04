require 'spec/spec_helper'
require 'jobs'

describe HourlyScan do
  it 'should be in the scans queue' do
    HourlyScan.instance_variable_get(:@queue).should == :scans
  end
end

describe HourlyScan, '.perform' do
  it "should find apps that need to run this hour"
  it "should enqueue a job for each"
end
