require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  before(:each) do 
    @user = User.create(:email => "user@email.com", :password => "password")
    sign_in @user
  end

  let(:valid_attributes) {
    {
      email: "email@email.com",
      password: "123456"
    }
  }

  describe "GET #request_admin" do
    it "raises an error for HTML formats" do
      expect{ get :request_admin }.to raise_error(ActionController::RoutingError)
    end

    it "fails the response if user is not signed in" do
      sign_out @user
      get :request_admin, format: :json
      expect(response).not_to be_success
    end

    it "serves a success json after sending request" do
      get :request_admin, format: :json
      expect(response.body).to eq({ success: 'Admin request sent.' }.to_json)
    end

    it "serves an error json if user is already admin" do
      @user.admin = true
      @user.save
      get :request_admin, format: :json
      expect(response.body).to eq({ error: 'User already admin.' }.to_json)
    end
  end

  describe "GET #request_token" do
    it "raises an error for HTML formats" do
      expect{ get :request_token }.to raise_error(ActionController::RoutingError)
    end

    it "fails the response if user is not signed in" do
      sign_out @user
      get :request_token, format: :json
      expect(response).not_to be_success
    end

    it "gets the token for the current user" do
      get :request_token, format: :json
      expect(response.body).to eq({ 
        user: @user.email,
        token: @user.authentication_token 
      }.to_json)
    end
  end
end
