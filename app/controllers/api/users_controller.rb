class Api::UsersController < Api::ApiController
  acts_as_token_authentication_handler_for User
  before_action :authenticate_user!

  def request_admin
    if current_user.admin?
      render_json_only({ error: 'User already admin.' })
      return
    end
    UserMailer.request_admin(current_user).deliver
    render_json_only({ success: 'Admin request sent.' })
  end

  def request_token
    render_json_only({ 
      user: current_user.email,
      token: current_user.authentication_token 
    })
  end
end
