class User < ApplicationRecord
  def self.request(token, sublink)
    headers = {Authorization: "bearer #{token}", "User-Agent": "apicurious by aelschauer"}
    HTTParty.get("https://oauth.reddit.com/#{sublink}", headers: headers)
  end

  def self.from_reddit(data, token)
    user = User.find_or_create_by(uid: data["name"], provider: 'reddit')
    user.update(token: token)
    user
  end

  def karma
    data = User.request(token, "/api/v1/me")
    { link: data["link_karma"], comment: data["comment_karma"] }
  end

  def subreddit_subscriptions
    response = User.request(token, "/subreddits/mine/subscriber")
    subreddits = response["data"]["children"]
    subreddits.map { |subreddit| subreddit["data"]["url"] }
  end
end
