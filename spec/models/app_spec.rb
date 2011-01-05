require 'spec/spec_helper'

describe App do
  it { should respond_to(:heroku_id) }
  it { should respond_to(:callback_url) }
  it { should respond_to(:plan) }
  it { should respond_to(:period) }
  it { should respond_to(:last_attempted) }
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

  end
end

