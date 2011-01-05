require 'spec/spec_helper'
require 'jobs'

describe HourlyScan do
  it 'should be in the scans queue' do
    HourlyScan.instance_variable_get(:@queue).should == :scans
  end
end

describe HourlyScan, '.perform' do
  before(:each) do
    @app1 = App.create
    @app2 = App.create
  end

  it "should enqueue a job for each app" do
    Resque.should_receive(:enqueue).with(RunAppCron, @app1.id)
    Resque.should_receive(:enqueue).with(RunAppCron, @app2.id)
    HourlyScan.perform
  end

  it "should only enqueue apps that need to run this hour"
end
