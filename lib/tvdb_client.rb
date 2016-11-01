require 'faraday'
require 'json'

class TvdbClient 
  attr_reader :api_key, :token

  def initialize(api_key)
    @api_key = api_key
  end

  def get_hash(url, req_url="", body="")
    conn = Faraday.new(url)
    resp = conn.post do |req|
      req.url req_url
      req.headers["Content-Type"] = "application/json"
      req.body = body
    end
    JSON.parse(resp.body)
  end

  def get_tvdb_hash(req_url, body="")
    get_hash("https://api.thetvdb.com", req_url, body)
  end

  def authenticate
    if valid_token?
      @token = TvdbToken.first
    else
      req_url = "/login"
      body = '{ "apikey": "' + @api_key + '" }'
      resp = get_tvdb_hash(req_url, body)
      @token = resp["token"]
    end
  end

  def save_token
    first = TvdbToken.first
    if first
      TvdbToken.update(first.id, :token => @token)
    else
      TvdbToken.create(:token => @token)
    end
  end

  def valid_token?
    first = TvdbToken.first
    if first
      (Time.now - first.updated_at)/1.day < 1
    end
  end

  private :get_hash, :get_tvdb_hash, :save_token, :valid_token?
end
