require 'rails_helper'
require 'tvdb_client'

RSpec.describe "TVDB Client", :vcr do
  before(:each) do
    @KEY = Rails.application.secrets.TVDB_KEY
    @client = TVDBClient.new(@KEY)
  end

  describe "get hash" do
    it "downloads and parses json" do
      url = "https://api.thetvdb.com/" 
      hash = @client.send(:get_hash, url)
      expect(hash).to be_an_instance_of(Hash)
    end

    it "throws an error if not json url" do
      url = "http://google.com/"
      expect { @client.send(:get_hash, url) }.to raise_error(JSON::ParserError)
    end
  end

  describe "get tvdb hash" do
    it "retrieves the json from a tvdb request url" do
      req_url = "/login"
      hash = @client.send(:get_tvdb_hash, req_url)
      expect(hash).to be_an_instance_of(Hash)
    end
  end

  describe "authenticates the client" do
    it "retrieves and sets the client's token" do
      token = @client.authenticate
      expect(token).not_to be_nil
      expect(@client.token).not_to be_nil
    end
  end
end
