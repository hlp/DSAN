class Notifier < ActionMailer::Base
  default :from => "designscriptarchivenetwork@gmail.com",
          :return_path => "designscriptarchivenetwork@gmail.com"

  def welcome_email(user)
    @user = user
    mail(:to => user.email,
         :subject => "Welcome to DSAN")
  end

  def password_change(user, password)
    @user = user
    @password = password
    mail(:to => user.email,
         :subject => "Password changed")
  end

end
