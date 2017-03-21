class Subreddit < OpenStruct
  # attr_reader :reddit_api

  def self.service(token)
    @reddit_api ||= RedditRequest.new(token)
  end

  def self.build(token, display_name)
    service(token)
    data = {
      rules: @reddit_api.subreddit_rules(display_name),
      moderators: @reddit_api.subreddit_moderators(display_name),
      hot_posts: @reddit_api.subreddit_hot_posts(display_name)
    }
    data.merge!(@reddit_api.subreddit_info(display_name))

    Subreddit.new(data)
  end

end