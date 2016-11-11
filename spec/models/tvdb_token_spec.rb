require 'rails_helper'

RSpec.describe TvdbToken, type: :model do
  before(:each) do
    @tvdb_token = TvdbToken.create({ token: "132321" })
  end

  it "creates a valid tvdb token" do
    expect(@tvdb_token).to be_valid
  end
end
