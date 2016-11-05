require 'rails_helper'

RSpec.describe "shows/search", type: :view do
  before(:each) do
    @show = assign(:show, Show.create!(
      :tvdb_id => "MyString",
      :name => "MyString",
      :season => 1,
      :episode => 1
    ))
    @possible_shows = assign(:possible_shows, [
        { "seriesName": "Fake Show 1", "id": "123" },
        { "seriesName": "Fake Show 2", "id": "455" }
    ])
  end

  it "renders the search shows form" do
    render
    assert_select "form[action=?][method=?]", show_path(@show), "post" do
      assert_select "input#show_tvdb_id[name=?]", "show[tvdb_id]"
    end
  end
end
