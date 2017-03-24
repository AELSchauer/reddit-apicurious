class Post < OpenStruct
  attr_reader :author, :id, :num_comments, :parent_sub,
              :score, :selftext, :title, :url

  def initialize(params)
    @author       = params["author"]
    @comments     = params["comments"]
    @id           = params["id"]
    @name         = params["name"]
    @num_comments = params["num_comments"]
    @score        = params["score"]
    @selftext     = params["selftext_html"]
    @parent_sub   = params["subreddit"]
    @title        = params["title"]
    @url          = params["url"]
  end

  def self.service(token)
    @reddit_api ||= RedditRequestService.new(token)
  end

  def self.build(token, display_name, post_id)
    service(token)
    data = { "comments" => @reddit_api.post_comments(display_name, post_id) }
    data.merge!(@reddit_api.post_info(display_name, post_id))

    Post.new(data)
  end

  def self.create_many(posts)
    posts.map { |post| Post.new(post["data"]) }
  end

  def comments
    Comment.create_tree(@comments)
  end
end