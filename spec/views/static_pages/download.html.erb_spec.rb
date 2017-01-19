require 'rails_helper'

RSpec.describe "static_pages/download", type: :view do
  it "renders a link to download the android app" do
    render
    assert_select "a[href]", :text => "here".to_s, :count => 2
  end
end
