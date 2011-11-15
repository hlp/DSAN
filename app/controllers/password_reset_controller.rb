class PasswordResetController < ApplicationController
  def new
    @title = "Reset Password"
  end

  def create
    email = params[:password_reset][:email]

    if User.forgot_password(email)
      flash[:success] = "Reset email sent to #{email}"
    else
      flash[:error] = "Unable to reset password for #{email}. Please check that it is correct."
    end

    redirect_to root_path
  end

end
