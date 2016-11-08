require 'rails_helper'

RSpec.describe Show, type: :model do
  before(:each) do
    @show = Show.create({name: "Scrubs"})
  end

  it "creates a valid show" do
    expect(@show).to be_valid
  end

  it "makes sure the show's name exists" do
    @show.name = ""
    expect(@show).not_to be_valid
  end

  it "makes sure the show's tvdb id is unique" do
    @show.tvdb_id = "123"
    @show.save
    duplicated = @show.dup
    expect(duplicated).not_to be_valid
  end

  it "allows shows with nil tvdb ids" do
    @show.tvdb_id = nil
    @show.save
    duplicated = @show.dup
    expect(duplicated).to be_valid
  end

  it "sets tvdb id to nil if it is blank" do
    show = Show.create({
      name: "Scrubs",
      tvdb_id: "",
    })
    expect(show.tvdb_id).to be_nil
  end
end
