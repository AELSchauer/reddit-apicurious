class User < ApplicationRecord
  def self.from_reddit(data, token)
    user = User.find_or_create_by(uid: data["name"], provider: 'reddit')
    user.update(token: token)
    user
  end

  def reddit_api
    @reddit_api ||= RedditRequest.new(token)
  end

  def karma
    response = reddit_api.request("/api/v1/me")
    { link: response["link_karma"], comment: response["comment_karma"] }
  end

  def trophies
    response = @reddit_api.request("/api/v1/me/trophies")
    response["data"]["trophies"].reduce({}) do |trophy_hash, trophy|
      trophy_name = trophy["data"]["name"]
      trophy_icon = trophy["data"]["icon_40"]
      trophy_hash.merge!(trophy_name => trophy_icon)
    end
  end

  def subreddit_subscriptions
    response = reddit_api.request("/subreddits/mine/subscriber")
    subreddits = response["data"]["children"]
    subreddits.map { |subreddit| subreddit["data"]["url"][3..-2].downcase }
  end
end
