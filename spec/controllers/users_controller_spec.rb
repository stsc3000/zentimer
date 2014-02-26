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
      expect(JSON.parse(response.body)).to eq({
        "tags" => [],
        "projects" => []
      })
    end

  end

  context "#put update" do
    render_views

    it "updates the users settings" do
      user = User.create
      expect(user.tags).to eq([])
      expect(user.projects).to eq([])

      put :update,
        token: user.token,
        user: { tags: ["tag1", "tag2"], projects: ["project1", "project2"] },
        format: :json

      expect(user.reload.tags).to eq(["tag1", "tag2"])
      expect(user.projects).to eq(["project1", "project2"])

      expect(JSON.parse(response.body)).to eq({
        "tags" => ['tag1', 'tag2'],
        "projects" => ['project1', 'project2']
      })

    end
  end

end
