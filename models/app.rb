class App < CouchRest::Model::Base
  use_database DB
  property :heroku_id
  property :callback_url
  property :plan
  property :last_attempted, Time
  timestamps!

  view_by :last_attempted,
    :map => %Q(function(doc) {
                 if (doc['couchrest-type'] === 'App') {
                   emit(doc['last_attempted'],null); }}),
    :reverse => true
end
