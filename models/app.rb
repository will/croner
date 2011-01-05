class App < CouchRest::Model::Base
  use_database DB
  property :heroku_id
  property :callback_url
  property :plan
  property :period, Integer, :default => 60
  property :last_attempted, Time
  property :next_scheduled, Time
  timestamps!

  after_create :enqueue

  def enqueue
    Resque.enqueue RunAppCron, id
  end

  def enqueue_next
    Resque.enqueue_in period, RunAppCron, id
    self.next_scheduled = Time.now + period
  end

  def post_cron_job
    RestClient.post(
      ENV['CRON_POST_URL'],
      JSON.dump({:heroku_id => heroku_id}),
      :content_type => :json)
  end
end
