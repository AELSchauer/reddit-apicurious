class Subreddit
  attr_reader :display_name, :rules, :url

  def initialize(params)
    @display_name = params["display_name"]
    @id           = params["id"]
    @moderators   = params["moderators"]
    @name         = params["name"]
    @posts        = params["posts"]
    @rules        = params["rules"]
    @subscribers  = params["subscribers"]
    @url          = params["url"]
  end

  def self.service(token)
    @reddit_api ||= RedditRequest.new(token)
  end

  def self.build(token, display_name)
    service(token)
    data = {
      "rules" => @reddit_api.subreddit_rules(display_name),
      "moderators" => @reddit_api.subreddit_moderators(display_name),
      "posts" => @reddit_api.subreddit_hot_posts(display_name)
    }
    data.merge!(@reddit_api.subreddit_info(display_name))

    Subreddit.new(data)
  end

  def posts
    Post.create_many(@posts)
  end

  def moderators
    ViewUser.create_many
  end

end