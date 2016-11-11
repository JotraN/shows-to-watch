require 'rails_helper'

RSpec.describe ShowsController, type: :controller do
  let(:valid_attributes) {
    {
      name: "scrubs",
      tvdb_id: nil,
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

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all shows as @shows" do
      show = Show.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:shows)).to eq([show])
    end
  end

  describe "GET #show" do
    it "assigns the requested show as @show" do
      show = Show.create! valid_attributes
      get :show, params: {id: show.to_param}, session: valid_session
      expect(assigns(:show)).to eq(show)
    end
  end

  describe "GET #new" do
    it "assigns a new show as @show" do
      sign_in User.create(:email => "user@email.com", :password => "password")
      get :new, params: {}, session: valid_session
      expect(assigns(:show)).to be_a_new(Show)
    end

    it "redirects to sign in if user is not signed in" do
      get :new, params: {}, session: valid_session
      expect(response).to redirect_to :new_user_session
    end
  end

  describe "GET #edit" do
    it "assigns the requested show as @show" do
      show = Show.create! valid_attributes
      get :edit, params: {id: show.to_param}, session: valid_session
      expect(assigns(:show)).to eq(show)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Show" do
        expect {
          post :create, params: {show: valid_attributes}, session: valid_session
        }.to change(Show, :count).by(1)
      end

      it "assigns a newly created show as @show" do
        post :create, params: {show: valid_attributes}, session: valid_session
        expect(assigns(:show)).to be_a(Show)
        expect(assigns(:show)).to be_persisted
      end

      it "redirects to the created show" do
        post :create, params: {show: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Show.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved show as @show" do
        post :create, params: {show: invalid_attributes}, session: valid_session
        expect(assigns(:show)).to be_a_new(Show)
      end

      it "re-renders the 'new' template" do
        post :create, params: {show: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
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

      it "updates the requested show" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: new_attributes}, session: valid_session
        show.reload
        expect(show.tvdb_id).to eq(new_attributes[:tvdb_id])
        expect(show.episode).to eq(new_attributes[:episode])
      end

      it "assigns the requested show as @show" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: valid_attributes}, session: valid_session
        expect(assigns(:show)).to eq(show)
      end

      it "redirects to the show" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: valid_attributes}, session: valid_session
        expect(response).to redirect_to(show)
      end
    end

    context "with invalid params" do
      it "assigns the show as @show" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: invalid_attributes}, session: valid_session
        expect(assigns(:show)).to eq(show)
      end

      it "re-renders the 'edit' template" do
        show = Show.create! valid_attributes
        put :update, params: {id: show.to_param, show: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested show" do
      show = Show.create! valid_attributes
      expect {
        delete :destroy, params: {id: show.to_param}, session: valid_session
      }.to change(Show, :count).by(-1)
    end

    it "redirects to the shows list" do
      show = Show.create! valid_attributes
      delete :destroy, params: {id: show.to_param}, session: valid_session
      expect(response).to redirect_to(shows_url)
    end
  end

  describe "GET #search", :vcr do
    it "assigns the list of possible tvdb shows as @possible_shows" do
      show = Show.create! valid_attributes
      put :search, params: {id: show.to_param, show: valid_attributes}, session: valid_session
      expect(assigns(:possible_shows)).not_to be_nil
    end
  end
end
