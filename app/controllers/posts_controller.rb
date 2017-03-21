class PostsController < ApplicationController
  def show
    binding.pry
    @post = Post.new(current_user.token, params[:title], params[:post_id])
  end
end