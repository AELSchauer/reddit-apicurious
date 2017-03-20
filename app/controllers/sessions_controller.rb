class SessionsController < ApplicationController
  def create

  end

  def destroy

  end

  private

    def login_params
      params.permit(:code, :state)
    end
end