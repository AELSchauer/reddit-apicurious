class Subreddit
  attr_reader :title

  def initialize(token, title)
    @token = token
    @title = title
    @reddit_api = RedditRequest.new(token)
  end

  def hot_posts
    response = @reddit_api.request("/r/#{title}/hot")
    articles = response['data']['children']
    top_fifteen = articles.find_all { |article| not article['data']['stickied'] }[0..15]
    # binding.pry
    top_fifteen
  end
end