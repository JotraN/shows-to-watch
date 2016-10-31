require 'faraday'
require 'json'

class TVDBClient 
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
    req_url = "/login"
    body = '{ "apikey": "' + @api_key + '" }'
    resp = get_tvdb_hash(req_url, body)
    @token = resp["token"]
  end

  private :get_hash, :get_tvdb_hash
end
