require 'spec/spec_helper'
require 'jobs'

describe RunAppCron do
  it 'should be in the scans queue' do
    RunAppCron.instance_variable_get(:@queue).should == :runappcron
  end
end

describe RunAppCron, '.perform' do
  before(:each) do
    @app = App.create
  end

  def do_perform
    RunAppCron.perform(@app.id)
  end

  it 'should get passed an the app from the id' do
    App.should_receive(:get).with(@app.id).and_return(@app)
    do_perform
  end

  it 'should have heroku run the cron job'
  it 'should record the run'
  it 'should update the last attempt time' do
    @app.last_attempted.should be_nil
    do_perform
    refreshed = App.get @app.id
    refreshed.last_attempted.should_not be_nil
  end
end
