require 'spec_helper'

describe User do

  it "has a long hash on building" do
    user = User.new
    expect(user.token.length) == 64
    expect(user).to be_valid
  end

  it "is not valid without a token" do
    user = User.new
    user.token = nil
    expect(user).not_to be_valid
  end

  it "has tags" do
    user = User.new
    expect(user.tags).to eq([])
  end

  it "has projects" do
    user = User.new
    expect(user.projects).to eq([])
  end


end
