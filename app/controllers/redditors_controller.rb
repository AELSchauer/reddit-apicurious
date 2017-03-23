class RedditorsController < ApplicationController
  def show
    @user = Redditor.build(current_user.token, params[:username])
  end
end