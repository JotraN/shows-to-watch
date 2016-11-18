require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do 
    @user = User.create(:email => "user@email.com", :password => "password", :admin => true)
    sign_in @user
  end

  let(:valid_attributes) {
    {
      email: "email@email.com",
      password: "123456"
    }
  }

  describe "GET #index" do
    it "assigns all users as @users" do
      user = User.create! valid_attributes
      get :index
      expect(assigns(:users)).to eq([@user, user])
    end

    it "fails the response if user is not signed in" do
      sign_out @user
      get :index
      expect(response).not_to be_success
    end

    it "redirects to shows if user is not admin" do
      @user.admin = false
      @user.save
      get :index
      expect(response).to redirect_to(shows_url)
    end
  end

  describe "PUT #update" do
    let(:new_attributes) {
      {
        email: "change_user@email.com",
        admin: true
      }
    }

    it "updates the requested user" do
      user = User.create! valid_attributes
      put :update, params: {id: user.to_param, user: new_attributes}
      user.reload
      expect(user.email).to eq(new_attributes[:email])
      expect(user.admin).to eq(new_attributes[:admin])
    end

    it "does not update if the requested user is an admin and not the current user" do
      user = User.create! valid_attributes
      user.admin = true
      user.save
      put :update, params: {id: user.to_param, user: new_attributes}
      user.reload
      expect(user.email).to eq(valid_attributes[:email])
    end

    it "updates the requested user is an admin and the current user" do
      put :update, params: {id: @user.to_param, user: new_attributes}
      @user.reload
      expect(@user.email).to eq(new_attributes[:email])
    end

    it "assigns the requested user as @show" do
      user = User.create! valid_attributes
      put :update, params: {id: user.to_param, user: valid_attributes}
      expect(assigns(:user)).to eq(user)
    end

    it "redirects to users" do
      user = User.create! valid_attributes
      put :update, params: {id: user.to_param, user: valid_attributes}
      expect(response).to redirect_to(users_url)
    end

    it "fails the response if user is not signed in" do
      sign_out @user
      user = User.create! valid_attributes
      put :update, params: {id: user.to_param, user: valid_attributes}
      expect(response).not_to be_success
    end

    it "redirects to shows if user is not admin" do
      @user.admin = false
      @user.save
      user = User.create! valid_attributes
      put :update, params: {id: user.to_param, user: valid_attributes}
      expect(response).to redirect_to(shows_url)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete :destroy, params: {id: user.to_param}
      }.to change(User, :count).by(-1)
    end

    it "does not destroy if the requested user is an admin and not the current user" do
      user = User.create! valid_attributes
      user.admin = true
      user.save
      expect {
        delete :destroy, params: {id: user.to_param}
      }.to change(User, :count).by(0)
    end

    it "destroys the requested user is an admin and the current user" do
      expect {
        delete :destroy, params: {id: @user.to_param}
      }.to change(User, :count).by(-1)
    end


    it "redirects to the users list" do
      user = User.create! valid_attributes
      delete :destroy, params: {id: user.to_param}
      expect(response).to redirect_to(users_url)
    end

    it "fails the response if user is not signed in" do
      sign_out @user
      user = User.create! valid_attributes
      delete :destroy, params: {id: user.to_param}
      expect(response).not_to be_success
    end
    
    it "redirects to shows if user is not admin" do
      @user.admin = false
      @user.save
      user = User.create! valid_attributes
      delete :destroy, params: {id: user.to_param}
      expect(response).to redirect_to(shows_url)
    end
  end
end
