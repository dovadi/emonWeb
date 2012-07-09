class UserMailer < ActionMailer::Base
  default from: "noreply@#{HOST}"

  def reset_notification(reset)
    @user  = reset.user
    @reset = reset
    mail(:to => @user.email, :subject => 'Nanode reset notification!')
  end
end
