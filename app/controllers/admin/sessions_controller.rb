module Admin
  class SessionsController < ApplicationController
    layout false

    def new; end

    def create
      if AdminAuthentication.valid_credentials?(params[:username], params[:password])
        session[:admin_authenticated] = true
        redirect_to(session.delete(:admin_return_to).presence || admin_root_path)
      else
        flash.now[:alert] = "Username or password is incorrect."
        render :new, status: :unauthorized
      end
    end

    def destroy
      session.delete(:admin_authenticated)
      session.delete(:admin_return_to)
      redirect_to admin_login_path, notice: "Signed out."
    end
  end
end
