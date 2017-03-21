class Comment
  attr_reader :replies, :body, :data

  def initialize(comment_hash, depth=0)
    @data = comment_hash["data"]
    @depth = depth
    @body  = @data["body"]
    @replies = get_replies
  end

  def get_replies
    replies = []
    if !@data["replies"].nil? && !@data["replies"].empty?
      @data["replies"]["data"]["children"].each do |reply_hash|
        replies << Comment.new(reply_hash, @depth+1)
      end
    end
    replies
  end
end