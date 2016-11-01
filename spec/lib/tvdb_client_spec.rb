require 'rails_helper'
require 'tvdb_client'

RSpec.describe "Tvdb Client", :vcr do
  before(:each) do
    @KEY = Rails.application.secrets.TVDB_KEY
    @client = TvdbClient.new(@KEY)
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

    it "uses the db token if it is valid" do
      token = "token"
      TvdbToken.create(:token => token)
      @client.authenticate
      expect(@client.token).equal? token
    end
  end

  describe "saves the token" do
    it "saves the token to the tvdb table" do
      @client.authenticate
      @client.send(:save_token)
      expect(TvdbToken.first).not_to be_nil
    end

    it "updates the existing token in the tvdb table" do
      token = "token"
      TvdbToken.create(:token => token)
      @client.authenticate
      @client.send(:save_token)
      expect(TvdbToken.first.token).not_to be(token)
    end
  end

  describe "determines if a valid token exists" do
    it "declares a token valid if it has been updated within a day" do
      TvdbToken.create(:updated_at => Time.now)
      expect(@client.send(:valid_token?)).to be(true)
    end

    it "declares a token invalid if it hasn't been updated within a day" do
      TvdbToken.create(:updated_at => Time.now - 2.day)
      expect(@client.send(:valid_token?)).to be(false)
    end
  end
end
