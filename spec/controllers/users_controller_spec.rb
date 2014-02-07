require 'spec_helper'

describe UsersController do
  context "#post create" do

    it "creates a user" do
      expect{
        post :create
      }.to change{ User.count }
    end

    it "returns the user url" do
      post :create
      expect(JSON.parse(response.body)).to eq({ "url" => user_url(assigns(:user)) })
    end

  end
end
