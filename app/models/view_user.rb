class ViewUser
  attr_reader :username

  def initialize(token, username)
    @token = token
    @username = username
    @reddit_api = RedditRequest.new(token)
  end

  def karma
    response = @reddit_api.request("/user/#{username}/about")
    info = response["data"]
    { link: info["link_karma"], comment: info["comment_karma"] }
  end

  def trophies
    response = @reddit_api.request("/api/v1/user/#{username}/trophies")
    response["data"]["trophies"].reduce({}) do |trophy_hash, trophy|
      trophy_name = trophy["data"]["name"]
      trophy_icon = trophy["data"]["icon_40"]
      trophy_hash.merge!(trophy_name => trophy_icon)
    end
  end
end