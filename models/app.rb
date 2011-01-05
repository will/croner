class App < CouchRest::Model::Base
  use_database DB
  property :heroku_id
  property :callback_url
  property :plan
  property :last_ran, Time
  timestamps!
end
