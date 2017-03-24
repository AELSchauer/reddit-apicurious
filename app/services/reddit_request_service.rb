class RedditRequestService
  def initialize(token)
    @token = token
  end

  def request(sublink)
    headers = {Authorization: "bearer #{@token}", "User-Agent": "#{ENV['app_name']} by aelschauer"}
    HTTParty.get("https://oauth.reddit.com/#{sublink}", headers: headers)
  end

  def user_info(username)
    response = request("/user/#{username}/about")
    info = response["data"]
  end

  def user_trophies(username)
    response = request("/api/v1/user/#{username}/trophies")
    response["data"]["trophies"].reduce({}) do |trophy_hash, trophy|
      trophy_name = trophy["data"]["name"]
      trophy_icon = trophy["data"]["icon_40"]
      trophy_hash.merge!(trophy_name => trophy_icon)
    end
  end

  def user_subreddit_subscriptions
    response = request("/subreddits/mine/subscriber")
    subscriptions = response["data"]["children"]
    subscriptions.sort_by { |subscription| subscription["data"]["display_name"].downcase }
  end

  def subreddit_info(display_name)
    response = request("/r/#{display_name}/about")
    response["data"]
  end

  def subreddit_rules(display_name)
    response = request("/r/#{display_name}/about/rules")
    response["rules"]
  end

  def subreddit_moderators(display_name)
    response = request("/r/#{display_name}/about/moderators")
    moderators = response["data"]["children"]
    moderators.sort_by { |moderator| moderator["name"].downcase }
  end

  def subreddit_posts(display_name, post_type)
    response = request("/r/#{display_name}/#{post_type}")
    articles = response["data"]["children"]
    articles.find_all { |article| not article["data"]["stickied"] }
  end

  def post_info(display_name, post_id)
    response = request("/r/#{display_name}/comments/#{post_id}")
    data = response[0]["data"]["children"][0]["data"]
  end

  def post_comments(display_name, post_id)
    response = request("/r/#{display_name}/comments/#{post_id}")
    response[1]["data"]["children"]
  end
end
