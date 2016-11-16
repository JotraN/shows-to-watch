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
    assert_select "a[href]", :text => "Name".to_s, :count => 2
    assert_select "span>em", :text => "2", :count => 2
    assert_select "span>em", :text => "3", :count => 2
    assert_select "span>em", :text => "false".to_s, :count => 2
    assert_select "a[href]", "Edit", :count => 2
  end
end
