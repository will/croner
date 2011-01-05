class App < CouchRest::Model::Base
  use_database DB
  property :heroku_id
  property :callback_url
  property :plan
  property :period, Integer, :default => 10
  property :last_attempted, Time
  timestamps!

  after_create :enqueue

  def enqueue
    Resque.enqueue RunAppCron, id
  end

  def enqueue_next
    Resque.enqueue_in period, RunAppCron, id
  end
end
