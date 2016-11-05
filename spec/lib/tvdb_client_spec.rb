require 'rails_helper'
require 'tvdb_client'

RSpec.describe "Tvdb Client", :vcr do
  before(:each) do
    @KEY = Rails.application.secrets.TVDB_KEY
    @client = TvdbClient.new(@KEY)
  end

  describe "initialize" do
    it "raises an error if the api key is nil" do
      expect {TvdbClient.new(nil)}.to raise_error(ArgumentError)
    end
  end

  describe "post request" do
    it "downloads and parses the response json" do
      url = "https://api.thetvdb.com/" 
      hash = @client.send(:post_req, url)
      expect(hash).to be_an_instance_of(Hash)
    end

    it "raises an error if the reponse is not json" do
      url = "http://google.com/"
      expect { @client.send(:post_req, url) }.to raise_error(JSON::ParserError)
    end
  end

  describe "get request" do
    it "downloads and parses the response json" do
      url = "https://api.thetvdb.com/" 
      hash = @client.send(:get_req, url, nil)
      expect(hash).to be_an_instance_of(Hash)
    end

    it "raises an error if the reponse is not json" do
      url = "http://google.com/"
      expect { @client.send(:get_req, url, nil) }.to raise_error(JSON::ParserError)
    end
  end

  describe "post tvdb hash" do
    it "retrieves the json from a tvdb post request" do
      req_url = "/login"
      hash = @client.send(:post_tvdb, req_url)
      expect(hash).to be_an_instance_of(Hash)
    end
  end

  describe "get tvdb hash" do
    it "retrieves the json from a tvdb get request" do
      @client.authenticate
      req_url = "/refresh_token"
      hash = @client.send(:get_tvdb, req_url)
      expect(hash).to be_an_instance_of(Hash)
    end

    it "raises an error if no token" do
      url = "/refresh_token"
      expect { @client.send(:get_tvdb, url) }.to raise_error(ArgumentError)
    end

    it "raises an error if invalid request url" do
      url = "/series/not_an_id"
      expect { @client.send(:get_tvdb, url) }.to raise_error(ArgumentError)
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

  describe "searches for a show" do
    it "returns a list of possible shows" do
      @client.authenticate
      show = "show"
      results = @client.search(show)
      expect(results).to be_an_instance_of(Array)
    end

    it "raises an error if shows weren't found" do
      @client.authenticate
      show = "probably not a tv show dasdawefa"
      expect { @client.search(show) }.to raise_error(ArgumentError)
    end
  end

  describe "retrieves information for a show" do
    it "returns a hash containing show information" do
      @client.authenticate
      show_id = "76156"
      expect(@client.retrieve_show(show_id)).not_to be_nil
    end

    it "raises an error if the show isn't found" do
      @client.authenticate
      show_id = "not_an_id"
      expect { @client.retrieve_show(show_id) }.to raise_error(ArgumentError)
    end
  end
end
