class RedditRequest
  def initialize(token)
    @token = token
  end

  def request(sublink)
    headers = {Authorization: "bearer #{@token}", "User-Agent": "#{ENV['app_name']} by aelschauer"}
    HTTParty.get("https://oauth.reddit.com/#{sublink}", headers: headers)
  end

  def subreddit_info(display_name)
    response = request("/r/#{display_name}/about")
    response["data"].select { |key, value| ["id", "name", "url", "display_name", "subscribers"].include?(key) }
  end

  def subreddit_rules(display_name)
    response = request("/r/#{display_name}/about/rules")
    response["rules"]
  end

  def subreddit_moderators(display_name)
    response = request("/r/#{display_name}/about/moderators")
    moderators = response["data"]["children"]
    moderators.sort_by { |moderator| moderator["name"] }
  end

  def subreddit_hot_posts(display_name)
    response = request("/r/#{display_name}/hot")
    articles = response["data"]["children"]
    # articles.find_all { |article| not article["data"]["stickied"] }[0..15]
    articles.find_all { |article| not article["data"]["stickied"] }
  end

  def post(display_name, post_id)
    response = request("/r/#{display_name}/comments/#{post_id}")
    response[0]["data"]["children"][0]["data"]
  end
end
