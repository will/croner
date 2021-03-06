require 'spec/spec_helper'

describe App do
  it { should respond_to(:heroku_id) }
  it { should respond_to(:callback_url) }
  it { should respond_to(:plan) }
  it { should respond_to(:period) }
  it { should respond_to(:total_runs) }
  it { should respond_to(:failed_runs) }
  it { should respond_to(:last_attempted) }
  it { should respond_to(:next_scheduled) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
end

describe App, 'after create' do
  it 'should enqueue the first run' do
    Resque.should_receive(:enqueue).once
    app = App.new
    app.save
    app.save
  end
end

describe App, '#enqueue' do
  it 'should enqueue itself' do
    app = App.create
    Resque.should_receive(:enqueue).with(RunAppCron, app.id)
    app.enqueue
  end
end

describe App, '#enqueue_next' do
  it 'should enqueue itself in period seconds' do
    app = App.create(:period => 8675309)
    Resque.should_receive(:enqueue_in).with(8675309, RunAppCron, app.id)
    app.enqueue_next
  end

  it 'should set its next time' do
    app = App.create(:period => 1.day.to_i)
    app.enqueue_next

    delta = app.next_scheduled.to_i - 1.day.from_now.to_i
    delta.should == 0
  end
end

describe App, "#post_cron_job" do
  before(:each) do
    @endpoint = 'http://stubbed.com/endpoint'
    ENV['CRON_POST_URL'] = @endpoint
    @app = App.new(:heroku_id => "an id")
  end

  context 'successful job' do
    before(:each) do
      stub_request(:post, 'stubbed.com/endpoint').to_return(:body => "ok", :status => 200)
    end

    it 'should make a post' do
      RestClient.should_receive(:post) do |url, *args|
        url.should == @endpoint
        args.should include(JSON.dump({:heroku_id => @app.heroku_id}))
        args.should include({:content_type => :json})
      end
      @app.post_cron_job
    end

    it 'should increase total runs' do
      expect { @app.post_cron_job }.to change(@app, :total_runs).by(1)
    end

    it 'should be true' do
      @app.post_cron_job.should be_true
    end
  end

  context "unsuccessful job" do
    before(:each) do
      stub_request(:post, 'stubbed.com/endpoint').to_return(:body => "ok", :status => 500)
    end

    it 'should return false' do
      @app.post_cron_job.should be_false
    end

    it 'should increase failed runs' do
      expect { @app.post_cron_job }.to change(@app, :failed_runs).by(1)
    end
  end
end



