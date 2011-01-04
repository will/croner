require 'spec/spec_helper'

describe 'provisioning' do
  it 'should return an id' do
    post '/heroku/resources', '{}'
    last_response.status.should == 200
    parsed.should have_key('id')
    parsed['id'].should_not be_nil
  end

  it 'should save a record' do
    post '/heroku/resources', {"heroku_id" => "app123@heroku.com"}.to_json
    DB.get(parsed['id'])['heroku_id'].should == "app123@heroku.com"
  end
end

describe 'deprovisioning' do
  it 'should return 404 if missing' do
    delete '/heroku/resources/thisisntanid'
    last_response.status.should == 404
  end

  it 'should delete the doc if it finds it' do
    doc = DB.save_doc :some => 'data'
    delete "/heroku/resources/#{doc['id']}"
    last_response.status.should == 200
    expect { DB.get doc['id'] }.to raise_error
  end
end
