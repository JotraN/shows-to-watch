require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #download" do
      it "renders the 'download' template" do
        get :download
        expect(response).to render_template("download")
      end
  end
end
