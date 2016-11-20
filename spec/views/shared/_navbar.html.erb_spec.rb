require 'rails_helper'

RSpec.describe "shared/_navbar", type: :view do
  it "renders a sign in if user is not signed in" do
    render
    expect(rendered).to match /Sign In/
  end

  it "renders a sign out if user is signed in" do
    sign_in User.create(email: "user@email.com", password: "password")
    render
    expect(rendered).to match /Sign Out/
  end

  it "renders an admin tool link if user is admin" do
    sign_in User.create(email: "user@email.com", password: "password", admin: true)
    render
    expect(rendered).to match /Admin Tools/
  end

  it "renders a request admin link if user is not admin" do
    sign_in User.create(email: "user@email.com", password: "password")
    render
    expect(rendered).to match /Request Admin/
  end

  it "renders a account if user is signed in" do
    sign_in User.create(email: "user@email.com", password: "password")
    render
    expect(rendered).to match /Account/
  end
end
