class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @users = User.all
  end

  def update
    if @user.admin? and @user != current_user
      redirect_to users_url, alert: "Can't edit other admins."
      return
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { render users_url, status: :ok, location: @show }
      else
        format.html { redirect_to users_url, alert: 'User was unsuccessfully updated.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @user.admin? and @user != current_user
      redirect_to users_url, alert: "Can't edit other admins."
      return
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :admin)
    end

    def authenticate_admin!
      if not current_user.admin?
        redirect_to shows_url, alert: "Only admins can do that."
        return
      end
    end
end
