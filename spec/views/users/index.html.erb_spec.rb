require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :email => "email@email.com",
        :password => "123456"
      ),
      User.create!(
        :email => "another@email.com",
        :password => "111111",
        :admin => true
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "email@email.com", :count => 1
    assert_select "tr>td", :text => "another@email.com", :count => 1
    assert_select "tr>td", :text => "Admin", :count => 1
    assert_select "tr>td", :text => "User", :count => 1
    assert_select "a[href]", :text => "Delete", :count => 2
  end
end
