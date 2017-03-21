class SubredditsController < ApplicationController
  def show
    @subreddit = Subreddit.new(current_user.token, params[:title])
  end
end