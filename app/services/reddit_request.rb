class RedditRequest
  def initialize(token)
    @token = token
  end

  def request(sublink)
    headers = {Authorization: "bearer #{@token}", "User-Agent": "apicurious by aelschauer"}
    HTTParty.get("https://oauth.reddit.com/#{sublink}", headers: headers)
  end
end