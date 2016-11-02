require 'faraday'
require 'json'

class TvdbClient 
  attr_reader :api_key, :token

  def initialize(api_key)
    @api_key = api_key
  end

  def post_req(url, req_url="", body="")
    conn = Faraday.new(url)
    resp = conn.post do |req|
      req.url req_url
      req.headers["Content-Type"] = "application/json"
      req.body = body
    end
    JSON.parse(resp.body)
  end

  def get_req(url, token, req_url="", body="")
    conn = Faraday.new(url)
    resp = conn.get do |req|
      req.url req_url
      req.headers["Content-Type"] = "application/json"
      req.headers["Authorization"] = "Bearer #{ token }"
      req.body = body
    end
    JSON.parse(resp.body)
  end

  def post_tvdb(req_url, body="")
    post_req("https://api.thetvdb.com", req_url, body)
  end

  def get_tvdb(req_url, body="")
    if not @token
      raise ArgumentError, "Token required for get requests."
    end
    get_req("https://api.thetvdb.com", @token, req_url, body)
  end

  def authenticate
    if valid_token?
      @token = TvdbToken.first
    else
      req_url = "/login"
      body = '{ "apikey": "' + @api_key + '" }'
      resp = post_tvdb(req_url, body)
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

  def search(show)
    req_url = "/search/series?name=#{ show }"
    get_tvdb(req_url)["data"]
  end

  private :post_req, :get_req, :post_tvdb, :get_tvdb, :save_token, :valid_token?
end
