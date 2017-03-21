class ViewUsersController < ApplicationController
  def show
    @user = ViewUser.new(current_user.token, params[:username])
  end
end