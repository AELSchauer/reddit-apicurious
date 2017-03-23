class User < ApplicationRecord
  def self.from_reddit(data, token)
    user = User.find_or_create_by(uid: data["name"], provider: 'reddit')
    user.update(token: token)
    user
  end

  def reddit_api
    @reddit_api ||= RedditRequestService.new(token)
  end

  def subreddit_subscriptions
    subreddits = reddit_api.user_subreddit_subscriptions
    subreddits.map { |subreddit| Subreddit.new(subreddit["data"]) }
  end
end
