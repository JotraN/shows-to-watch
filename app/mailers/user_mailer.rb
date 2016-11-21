class UserMailer < ApplicationMailer
  def request_admin(user)
    @user = user
    bot_email = 'showstowatchbot@josephtran.io'
    mail(to: bot_email, from: bot_email, 
         subject: "ADMIN REQUEST: #{ user.email }")
  end

  def grant_admin(user)
    @user = user
    bot_email = 'showstowatchbot@josephtran.io'
    mail(to: user.email, from: bot_email, 
         subject: "ADMIN REQUEST GRANTED: #{ user.email }")
  end
end
