require 'rails_helper'

RSpec.describe "shows/edit", type: :view do
  before(:each) do
    @show = assign(:show, Show.create!(
      :tvdb_id => "MyString",
      :name => "MyString",
      :season => 1,
      :episode => 1
    ))
  end

  it "renders the edit show form" do
    render
    assert_select "form[action=?][method=?]", show_path(@show), "post" do
      assert_select "input#show_name[name=?]", "show[name]"
      assert_select "input#show_season[name=?]", "show[season]"
      assert_select "input#show_episode[name=?]", "show[episode]"
      assert_select "input#show_completed[name=?]", "show[completed]"
      assert_select "input#show_abandoned[name=?]", "show[abandoned]"
      assert_select "a[href=?]", "/shows/#{ @show.id }/search"
    end
  end

  it "renders the delete button" do
    render
    assert_select "a[href=?]", "/shows/#{ @show.id }"
  end
end
