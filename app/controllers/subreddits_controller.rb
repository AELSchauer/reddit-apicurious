class SubredditsController < ApplicationController
  def show
    @subreddit = Subreddit.build(current_user.token, params[:subreddit_name])
  end
end