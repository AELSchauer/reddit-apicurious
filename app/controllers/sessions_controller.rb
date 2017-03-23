class SessionsController < ApplicationController
  def create
    oauth = RedditOauthService.new(login_params)
    token = oauth.token
    data  = oauth.data

    @user = User.from_reddit(data, token)
    session[:user_id] = @user.id
    redirect_to dashboard_index_path
  end

  def destroy
    session.clear

    redirect_to root_path
  end

  private

    def login_params
      params.permit(:code, :state)
    end
end
