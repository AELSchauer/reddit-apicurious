class Redditor
  attr_reader :comment_karma, :link_karma, :name, :trophies

  def initialize(params)
    @comment_karma = params["comment_karma"]
    @id            = params["id"]
    @link_karma    = params["link_karma"]
    @name          = params["name"]
    @trophies      = params["trophies"]
  end

  def self.service(token)
    @reddit_api ||= RedditRequest.new(token)
  end

  def self.build(token, username)
    service(token)
    data = {
      "trophies" => @reddit_api.user_trophies(username)
    }
    data.merge!(@reddit_api.user_info(username))

    Redditor.new(data)
  end

  def self.create_many(users)
    users.map { |user_data| Redditor.new(user_data) }
  end
end