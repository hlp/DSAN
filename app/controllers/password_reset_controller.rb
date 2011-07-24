class PasswordResetController < ApplicationController
  def new
    @title = "Reset Password"
  end

  def create
    email = params[:password_reset][:email]
    flash[:success] = "Reset email sent to #{email}";
    User.forgot_password(email)
    redirect_to root_path
  end

end
