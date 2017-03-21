class Subreddit
  attr_reader :title

  def initialize(token, title)
    @token = token
    @title = title
    @reddit_api = RedditRequest.new(token)
  end

  def rules
    response = @reddit_api.request("/r/#{title}/about/rules")
    response["rules"]
  end

  def moderators
    response = @reddit_api.request("/r/#{title}/about/moderators")
    moderators = response["data"]["children"]
    moderators.sort_by { |moderator| moderator["name"] }
  end

  def hot_posts
    response = @reddit_api.request("/r/#{title}/hot")
    articles = response["data"]["children"]
    articles.find_all { |article| not article["data"]["stickied"] }[0..15]
  end
end