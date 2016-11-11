require 'rails_helper'

RSpec.describe "shows/index", type: :view do
  before(:each) do
    assign(:shows, [
      Show.create!(
        :tvdb_id => "Tvdb",
        :name => "Name",
        :season => "2",
        :episode => "3"
      ),
      Show.create!(
        :tvdb_id => "Tvdb2",
        :name => "Name",
        :season => "2",
        :episode => "3"
      )
    ])
  end

  it "renders a list of shows" do
    render
    assert_select "div>em", :text => "2", :count => 2
    assert_select "div>em", :text => "3", :count => 2
    assert_select "div>em", :text => "false".to_s, :count => 2
    assert_select "div>h1", :text => "Name".to_s, :count => 2
  end

  it "renders a sign in if user is not signed in" do
    render
    expect(rendered).to match /Sign In/
  end

  it "renders a sign out if user is signed in" do
    sign_in User.create(email: "user@email.com", password: "password")
    render
    expect(rendered).to match /Sign Out/
  end
end
