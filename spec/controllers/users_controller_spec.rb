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
      expect(JSON.parse(response.body)).to eq({ "entries" => [] })
    end

  end

  context "#put update" do
    render_views

    it "updates the users entries" do
      user = User.create
      put :update, user: { entries: [{ "name" => "myEntry"}] }, token: user.token, format: :json
      expect(user.reload.entries).to eq([{ "name" => "myEntry"}])
    end
  end
end
