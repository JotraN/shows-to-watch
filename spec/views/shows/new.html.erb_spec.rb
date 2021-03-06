require 'rails_helper'

RSpec.describe "shows/new", type: :view do
  before(:each) do
    assign(:show, Show.new(
      :tvdb_id => "MyString",
      :name => "MyString",
      :season => 1,
      :episode => 1,
      :completed => 0
    ))
  end

  it "renders new show form" do
    render

    assert_select "form[action=?][method=?]", shows_path, "post" do
      assert_select "input#show_name[name=?]", "show[name]"
      assert_select "input#show_season[name=?]", "show[season]"
      assert_select "input#show_episode[name=?]", "show[episode]"
      assert_select "input#show_completed[name=?]", "show[completed]"
      assert_select "input#show_abandoned[name=?]", "show[abandoned]"
      assert_select "a[href]", :text => "Set TVDB Info", :count => 0
    end
  end
end
