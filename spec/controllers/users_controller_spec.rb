require 'spec_helper'

describe UsersController do
  context "#post create" do

    it "creates a user" do
      expect{
        post :create
      }.to change{ User.count }
    end

    it "redirects to the user" do
      expect(post :create).to redirect_to user_url(assigns(:user))
    end

  end
end
