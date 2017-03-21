class Post
  attr_reader :title, :id

  def initialize(token, title, id)
    @token = token
    @title = title
    @id    = id
    @reddit_api = RedditRequest.new(token)
  end
end