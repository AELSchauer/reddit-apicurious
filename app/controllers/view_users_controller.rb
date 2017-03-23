class ViewUsersController < ApplicationController
  def show
    @user = ViewUser.build(current_user.token, params[:username])
  end
end