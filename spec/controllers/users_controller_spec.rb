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
      expect(JSON.parse(response.body)).to eq({ "url" => user_url(assigns(:user).token) })
    end

  end

  context "#get show" do
    render_views

    it "returns the users json" do
      user = User.create
      get :show, token: user.token, format: :json
      expect(JSON.parse(response.body)).to eq({})
    end

  end

end
