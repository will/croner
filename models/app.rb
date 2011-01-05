class App < CouchRest::Model::Base
  use_database DB
  property :heroku_id
  property :callback_url
  property :plan
  property :last_attempted, Time
  timestamps!

  after_create :enqueue

  private

  def enqueue
    Resque.enqueue RunAppCron, id
  end
end
