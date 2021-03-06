require 'spec/spec_helper'
require 'jobs'

describe RunAppCron do
  it 'should be in the scans queue' do
    RunAppCron.instance_variable_get(:@queue).should == :runappcron
  end
end

describe RunAppCron, '.perform' do
  context 'with app present' do
    before(:each) do
      @app = App.create
      App.stub!(:get).and_return @app
      @app.stub!(:post_cron_job).and_return(true) # TODO: replace with webmock
    end

    def do_perform
      RunAppCron.perform(@app.id)
    end

    context "successful job" do
      it 'should get passed an the app from the id' do
        App.should_receive(:get).with(@app.id).and_return(@app)
        do_perform
      end

      it 'should have heroku run the cron job' do
        @app.should_receive :post_cron_job
        do_perform
      end

      it 'should record the run'
      it 'should update the last attempt time' do
        @app.last_attempted.should be_nil
        do_perform
        refreshed = App.get @app.id
        refreshed.last_attempted.should_not be_nil
      end

      it 'should save the app' do
        @app.should_receive :save
        do_perform
      end

      it 'should shouldnt retry' do
        @app.should_not_receive :retry
        do_perform
      end
    end

    context "when job fails" do
      before(:each) do
        @app.stub!(:post_cron_job).and_return false
      end

      it 'should requeue another try in 2 seconds' do
        @app.should_receive :retry
        do_perform
      end
    end
  end

  context 'when app has been deleted' do
    it 'should not enqueue another job' do
      Resque.should_not_receive :enqueue
      Resque.should_not_receive :enqueue_in
      RunAppCron.perform "missing app"
    end
  end
end
