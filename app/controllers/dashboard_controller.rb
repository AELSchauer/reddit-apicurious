class DashboardController < ApplicationController
  before_action :authorize!

  def index
    @user = Redditor.build(current_user.token, current_user.uid)
  end
end
