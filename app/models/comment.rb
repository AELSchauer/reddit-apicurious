class Comment
  attr_reader :body, :children, :id, :replies

  def initialize(params)
    @author   = params["author"]
    @body     = params["body"]
    @children = []
    @depth    = params["depth"]
    @id       = params["id"]
    @replies  = get_replies(params)
    @score    = params["score"]
  end

  def self.create_tree(comments)
    comments.map { |comment_hash| Comment.new(comment_hash["data"]) }
  end

  def get_replies(params)
    replies = []
    if params["replies"].nil?
      if not params["parent_id"].nil?
        replies << Comment.new("id" => params["parent_id"], "body" => "")
      end
    elsif not params["replies"].empty?
      params["replies"]["data"]["children"].map do |reply_hash|
        replies << Comment.new(reply_hash["data"])
      end
    end
    replies
  end
end