require 'rails_helper'

RSpec.describe Api::ShowsController, type: :controller do
  before(:each) do 
    @user = User.create(:email => "user@email.com", :password => "password", :admin => true)
    sign_in @user
    @token = @user.authentication_token
  end

  let(:valid_attributes) {
    {
      name: "scrubs",
      tvdb_id: "123",
      season: 1,
      episode: 1
    }
  }

  describe "GET #index" do
    it "raises an error for HTML formats" do
      expect{ get :index }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET #index.json" do
    it "assigns shows as @shows" do
      show = Show.create! valid_attributes
      get :index, format: :json
      expect(assigns(:shows)).to eq([show])
    end

    it "serves all shows from index as a json" do
      show = Show.create! valid_attributes
      get :index, format: :json
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq([show].to_json)
    end
  end

  describe "GET #abandoned" do
    it "raises an error for HTML formats" do
      expect{ get :abandoned }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET #abandoned.json" do
    it "serves abandoned shows as a json" do
      show = Show.create! valid_attributes
      show.abandoned = true
      show.save
      get :abandoned, format: :json
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq([show].to_json)
    end

    it "serves only abandoned shows as a json" do
      show = Show.create! valid_attributes
      show.abandoned = false
      show.save
      get :abandoned, format: :json
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq([].to_json)
    end
  end

  describe "GET #completed" do
    it "raises an error for HTML formats" do
      expect{ get :completed }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET #completed.json" do
    it "serves completed shows as a json" do
      show = Show.create! valid_attributes
      show.completed = true
      show.save
      get :completed, format: :json
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq([show].to_json)
    end

    it "serves only completed shows as a json" do
      show = Show.create! valid_attributes
      show.completed = false
      show.save
      get :completed, format: :json
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq([].to_json)
    end
  end

  describe "GET #in_progress" do
    it "raises an error for HTML formats" do
      expect{ get :in_progress }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET #in_progress.json" do
    it "serves in progress shows as a json" do
      show = Show.create! valid_attributes
      show.abandoned = false
      show.completed = false
      show.save
      get :in_progress, format: :json
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq([show].to_json)
    end

    it "serves only in progress shows as a json" do
      show = Show.create! valid_attributes
      show.abandoned = true
      show.save
      get :in_progress, format: :json
      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq([].to_json)
    end
  end
end
