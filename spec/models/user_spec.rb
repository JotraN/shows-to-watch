require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.create({ email: "email@email.com", password: "password" })
  end

  it "creates a valid user" do
    expect(@user).to be_valid
  end

  it "makes sure the user's email exists" do
    @user.email = ""
    expect(@user).not_to be_valid
  end

  it "makes sure the user's password exists" do
    @user.password = ""
    expect(@user).not_to be_valid
  end

  it "makes sure the user's email is unique" do
    @user.email = "123"
    @user.save
    duplicated = @user.dup
    expect(duplicated).not_to be_valid
  end

  it "makes sure the user's email is a valid email" do
    @user.email = "email"
    expect(@user).not_to be_valid
  end
end
