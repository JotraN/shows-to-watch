require 'rails_helper'

RSpec.describe "shows/index", type: :view do
  before(:each) do
    assign(:shows, [
      Show.create!(
        :tvdb_id => "Tvdb",
        :name => "Name",
        :season => 2,
        :episode => 3
      ),
      Show.create!(
        :tvdb_id => "Tvdb2",
        :name => "Name",
        :season => 2,
        :episode => 3
      )
    ])
  end

  it "renders a list of shows" do
    render
    assert_select "tr>td", :text => "Tvdb".to_s, :count => 1
    assert_select "tr>td", :text => "Tvdb2".to_s, :count => 1
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
