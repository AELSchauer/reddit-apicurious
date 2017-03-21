class Post
  attr_reader :subreddit, :id

  def initialize(token, subreddit, id)
    @token      = token
    @subreddit  = subreddit
    @id         = id
    @reddit_api = RedditRequest.new(token)
  end

  def title
    response = @reddit_api.request("/r/#{@subreddit}/comments/#{id}")
    response[0]["data"]["children"][0]["data"]["title"]
  end

  def comments
    response = @reddit_api.request("/r/#{@subreddit}/comments/#{id}")
    binding.pry
    response[1]["data"]["children"]
  end
end