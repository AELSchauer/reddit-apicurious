class Post
  attr_reader :subreddit, :id

  def initialize(token, subreddit, id)
    @token      = token
    @subreddit  = subreddit
    @id         = id
    @reddit_api = RedditRequest.new(token)
  end

  def find_by_subreddit
    
  end

  def text
    response = @reddit_api.request("/r/#{@subreddit}/comments/#{id}")
    response[0]["data"]["children"][0]["data"]["selftext_html"]
  end

  def title
    response = @reddit_api.request("/r/#{@subreddit}/comments/#{id}")
    response[0]["data"]["children"][0]["data"]["title"]
  end

  def comments
    response = @reddit_api.request("/r/#{@subreddit}/comments/#{id}")
    @comments = response[1]["data"]["children"].map { |comment_hash| Comment.new(comment_hash) }
  end
end