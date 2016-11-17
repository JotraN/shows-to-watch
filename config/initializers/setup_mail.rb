ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              =>  'smtp.sendgrid.net',
  :port                 =>  '587',
  :authentication       =>  :plain,
  :user_name            =>  ENV['STW_MAIL_USER'],
  :password             =>  ENV['STW_MAIL_PASS'],
  :domain               =>  ENV['STW_DOMAIN'],
  :enable_starttls_auto  =>  true
}
