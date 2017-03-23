class Comment
  attr_reader :children, :id, :replies

  def initialize(params)
    @author   = params["author"]
    @body     = params["body"]
    @depth    = params["depth"]
    @id       = params["id"]
    @replies  = get_replies(params)
    @score    = params["score"]
  end

  def self.create_tree(comments)
    comments.map { |comment_hash| Comment.new(comment_hash["data"]) }
  end

  def empty?
    false
  end

  def visible_reply?(params)
    params.keys.include?("replies") and not params["replies"].empty?
  end

  def hidden_reply?(params)
    params.keys.include?("parent_id") and not params.keys.include?("replies")
  end

  def body
    @body.nil? ? "" : @body
  end

  def get_replies(params)
    replies = []
    if visible_reply?(params)
      params["replies"]["data"]["children"].each do |reply_hash|
        replies << Comment.new(reply_hash["data"])
      end
    elsif hidden_reply?(params)
      replies << Comment.new("id" => params["parent_id"], "body" => "")
    end
    replies
  end
end