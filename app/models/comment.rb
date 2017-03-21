class Comment
  def initialize(comment_hash, depth=0)
    binding.pry
    @comment_hash = comment_hash
    @depth = depth
  end
end