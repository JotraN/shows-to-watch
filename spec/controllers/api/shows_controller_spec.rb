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

  let(:invalid_attributes) {
    {
      name: nil,
      tvdb_id: nil,
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

  describe "POST #create" do
    context "with valid params" do
      it "raises an error for HTML formats" do
        expect{ post :create, params: {show: valid_attributes} }
          .to raise_error(ActionController::RoutingError)
      end

      it "creates a new Show" do
        expect {
          post :create, params: {show: valid_attributes}, format: :json
        }.to change(Show, :count).by(1)
      end

      it "assigns a newly created show as @show" do
        post :create, params: {show: valid_attributes}, format: :json
        expect(assigns(:show)).to be_a(Show)
        expect(assigns(:show)).to be_persisted
      end

      it "serves show as json if tvdb id exists" do
        valid_attributes[:tvdb_id] = "123"
        post :create, params: {show: valid_attributes}, format: :json
        show = Show.last
        expect(response.body).to eq(show.to_json)
      end

      it "redirects to the search show if no tvdb id" do
        valid_attributes[:tvdb_id] = nil
        post :create, params: {show: valid_attributes}, format: :json
        expect(response).to redirect_to(search_api_show_url(Show.last, format: :json))
      end

      it "fails the response if user is not signed in" do
        sign_out @user
        post :create, params: {show: valid_attributes}, format: :json
        expect(response).not_to be_success
      end

      it "fails if the user is not an admin" do
        @user.admin = false
        @user.save
        post :create, params: {show: valid_attributes}, format: :json
        expect(response.body).to eq({ error: "Admin action only." }.to_json)
      end

      it "succeeds the response if user is not signed in, but has token" do
        sign_out @user
        post :create, params: {show: valid_attributes, 
                               user_email: @user.email, user_token: @token}, format: :json
        expect(response).to be_success
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved show as @show" do
        post :create, params: {show: invalid_attributes}, format: :json
        expect(assigns(:show)).to be_a_new(Show)
      end

      it "serves a json with the errors" do
        post :create, params: {show: invalid_attributes}, format: :json
        expect(response.body).to eq({ name: ["can't be blank"] }.to_json)
      end
    end
  end

  describe "GET #search", :vcr do
    it "raises an error for HTML formats" do
      show = Show.create! valid_attributes
      expect{ get :search, params: {id: show.to_param, show: valid_attributes} }
        .to raise_error(ActionController::RoutingError)
    end

    it "assigns the list of possible tvdb shows as @possible_shows" do
      show = Show.create! valid_attributes
      get :search, params: {id: show.to_param, show: valid_attributes}, format: :json
      expect(assigns(:possible_shows)).not_to be_nil
    end

    it "serves the list of possible tvdb shows as a json" do
      show = Show.create! valid_attributes
      get :search, params: {id: show.to_param, show: valid_attributes}, format: :json
      expect(response.body).to include("seriesName")
    end

    it "fails the response if user is not signed in" do
      sign_out @user
      show = Show.create! valid_attributes
      get :search, params: {id: show.to_param, show: valid_attributes}, format: :json
      expect(response).not_to be_success
    end

    it "fails if the user is not an admin" do
      @user.admin = false
      @user.save
      show = Show.create! valid_attributes
      get :search, params: {id: show.to_param, show: valid_attributes}, format: :json
      expect(response.body).to eq({ error: "Admin action only." }.to_json)
    end

    it "succeeds the response if user is not signed in, but has token" do
      sign_out @user
      show = Show.create! valid_attributes
      get :search, params: {id: show.to_param, show: valid_attributes,
                             user_email: @user.email, user_token: @token}, format: :json
      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          name: "scrubs",
          tvdb_id: "76156",
          season: 1,
          episode: 2
        }
      }

      it "raises an error for HTML formats" do
        show = Show.create! valid_attributes
        expect{ put :update, params: {id: show.to_param, show: valid_attributes} }
          .to raise_error(ActionController::RoutingError)
      end

      it "updates the requested show" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: new_attributes}, format: :json
        show.reload
        expect(show.tvdb_id).to eq(new_attributes[:tvdb_id])
        expect(show.episode).to eq(new_attributes[:episode])
      end

      it "assigns the requested show as @show" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: valid_attributes}, format: :json
        expect(assigns(:show)).to eq(show)
      end

      it "serves show as json if successful update" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: new_attributes}, format: :json
        expect(response.body).to eq(Show.last.to_json)
      end

      it "redirects to the search show if no tvdb id" do
        show = Show.create! valid_attributes
        valid_attributes[:tvdb_id] = nil
        put :update, params: {id: show.to_param, show: valid_attributes}, format: :json
        expect(response).to redirect_to(search_api_show_url(Show.last, format: :json))
      end

      it "fails the response if user is not signed in" do
        sign_out @user
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: new_attributes}, format: :json
        expect(response).not_to be_success
      end

      it "fails if the user is not an admin" do
        @user.admin = false
        @user.save
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: new_attributes}, format: :json
        expect(response.body).to eq({ error: "Admin action only." }.to_json)
      end

      it "succeeds the response if user is not signed in, but has token" do
        sign_out @user
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: new_attributes,
                               user_email: @user.email, user_token: @token}, format: :json
        expect(response).to be_success
      end
    end

    context "with invalid params" do
      it "assigns the show as @show" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: invalid_attributes}, format: :json
        expect(assigns(:show)).to eq(show)
      end

      it "serves a json with the errors" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: invalid_attributes}, format: :json
        expect(response.body).to eq({ name: ["can't be blank"] }.to_json)
      end
    end
  end

  describe "DELETE #destroy" do
    it "raises an error for HTML formats" do
      show = Show.create! valid_attributes
      expect {
        delete :destroy, params: {id: show.to_param}
      }.to raise_error(ActionController::RoutingError)
    end

    it "destroys the requested show" do
      show = Show.create! valid_attributes
      expect {
        delete :destroy, params: {id: show.to_param}, format: :json
      }.to change(Show, :count).by(-1)
    end

    it "serves a success json" do
      show = Show.create! valid_attributes
      delete :destroy, params: {id: show.to_param}, format: :json
      expect(response.body).to eq({ success: "Show was deleted." }.to_json)
    end

    it "fails the response if user is not signed in" do
      sign_out @user
      show = Show.create! valid_attributes
      delete :destroy, params: {id: show.to_param}, format: :json
      expect(response).not_to be_success
    end

    it "fails if the user is not an admin" do
      @user.admin = false
      @user.save
      show = Show.create! valid_attributes
      delete :destroy, params: {id: show.to_param}, format: :json
      expect(response.body).to eq({ error: "Admin action only." }.to_json)
    end

    it "succeeds the response if user is not signed in, but has token" do
      sign_out @user
      show = Show.create! valid_attributes
      delete :destroy, params: {id: show.to_param,
                             user_email: @user.email, user_token: @token}, format: :json
      expect(response).to be_success
    end
  end
end
