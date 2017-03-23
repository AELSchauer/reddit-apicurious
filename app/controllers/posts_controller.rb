class PostsController < ApplicationController
  def index
    @post = Post.build(current_user.token, params[:subreddit_name], params[:post_id])
  end
end