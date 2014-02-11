require 'spec_helper'

describe EntriesController do
  render_views

  before do
    @user = User.create
  end

  context "GET #index" do
    it "gets all the users entries" do
      entry = @user.entries.create
      get :index, token: @user.token
      expect(json_response).to eq(
        {:entries=>
          [{:id=>entry.id,
            :elapsed=>nil,
            :lastTick=>nil,
            :description=>nil,
            :running=>nil,
            :current=>nil}
          ]
        })
    end
  end

  context "GET #show" do
    it "gets a specific entry" do
      entry = @user.entries.create
      get :show, id: entry.id, token: @user.token
      expect(json_response).to eq(
        {
          entry: {:id=>entry.id,
                  :elapsed=>nil,
                  :lastTick=>nil,
                  :description=>nil,
                  :running=>nil,
                  :current=>nil}
        }
      )
    end
  end

  context "POST #create" do

    it "creates a new entry" do
      params = {
        :elapsed=>10,
        :lastTick=>"2012,12,12",
        :description=>"a description",
        :running=>true,
        :current=>true
      }
      expect{
        post :create, entry: params, token: @user.token
      }.to change{Entry.count}
    end

    it "renders the created entry" do
      params = {
        :elapsed=>10,
        :lastTick=>"2012-12-12",
        :description=>"a description",
        :running=>true,
        :current=>true
      }
      post :create, entry: params, token: @user.token
      entry_id = assigns(:entry).id
      expect(json_response).to eq(
        {:entry=>
          {:id=>entry_id,
          :elapsed=>10,
          :lastTick=>"2012-12-12T00:00:00Z",
          :description=>"a description",
          :running=>true,
          :current=>true}
        }
      )
    end

  end

  context "PUT #update" do

    it "updates an entry" do
      entry = @user.entries.create(description: "my description")

      params = {
        description: "new description"
      }

      expect {
        put :update, id: entry.id, entry: params, token: @user.token
      }.to change{entry.reload.description}.to("new description")

    end

    it "renders the entry" do
      entry = @user.entries.create(description: "my description")

      params = {
        description: "new description"
      }

      put :update, id: entry.id, entry: params, token: @user.token

      expect(json_response).to eq(
        {:entry=>
          {:id=>entry.id,
          :elapsed=> nil,
          :lastTick=> nil,
          :description=>"new description",
          :running=>nil,
          :current=>nil}
        }
      )
    end

  end

  context "DELETE #destroy" do
    it "destroys the entry" do
      entry = @user.entries.create(description: "my description")

      expect {
        delete :destroy, id: entry.id, token: @user.token
      }.to change{Entry.count}.from(1).to(0)

      expect(json_response).to eq({ status: "success" })
    end
  end
end
