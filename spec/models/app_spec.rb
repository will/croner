require 'spec/spec_helper'

describe App do
  it { should respond_to(:heroku_id) }
  it { should respond_to(:callback_url) }
  it { should respond_to(:plan) }
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
