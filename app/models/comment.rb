class Comment
  attr_reader :author, :depth, :id, :score

  def initialize(params)
    @author   = params["author"]
    @body     = params["body"]
    @depth    = params["depth"]
    @id       = params["id"]
    @params   = params
    @score    = params["score"]
  end

  def self.create_tree(comments)
    comments.map { |comment_hash| Comment.new(comment_hash["data"]) }
  end

  def empty?
    false
  end

  def has_replies?
    !@params["replies"].empty?
  end

  def children
    @params["replies"]["data"]["children"]
  end

  def children_visible?
    children.first["kind"] == "t1"
  end

  def body
    @body.nil? ? "" : @body
  end

  def replies
    arr = []
    if has_replies?
      if children_visible?
        children.each do |reply_hash|
          arr << Comment.new(reply_hash["data"])
        end
      else
        arr << Comment.new("body" => "")
      end
    end
    arr
  end
end