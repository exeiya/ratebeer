class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if user.closed
        redirect_to signin_path, notice: "Your account is closed, please contact admin"
      else
        session[:user_id] = user.id
        redirect_to user, notice: "Welcome back!"
      end
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

  def create_oauth
    auth_info = request.env["omniauth.auth"].info
    username = auth_info['nickname']
    user = User.find_by username: username
    if user
      if user.closed
        redirect_to signin_path, notice: "Your account is closed, please contact admin"
      else
        session[:user_id] = user.id
        redirect_to user, notice: "Welcome back!"
      end
    else
      user = User.create_oauth_user username
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome!"
    end
  end
end
