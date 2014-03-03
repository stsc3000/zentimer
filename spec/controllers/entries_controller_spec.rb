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
            :tag_list=>[],
            :running=>nil,
            :current=>nil,
            :project=>nil}
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
                  :tag_list=>[],
                  :running=>nil,
                  :current=>nil,
                  :project=>nil}
        }
      )
    end
  end

  context "POST #create" do

    it "creates a new entry" do
      params = {
        :elapsed=>10,
        :lastTick=>"2012,12,12",
        :tag_list=>["a tag"],
        :running=>true,
        :current=>true,
        :project=>"a project"
      }
      expect{
        post :create, entry: params, token: @user.token
      }.to change{Entry.count}
    end

    it "renders the created entry" do
      params = {
        :elapsed=>10,
        :lastTick=>"2012-12-12",
        :tag_list=>["a description"],
        :running=>true,
        :current=>true,
        :project=>"a project"
      }
      post :create, entry: params, token: @user.token
      entry_id = assigns(:entry).id
      expect(json_response).to eq(
        {:entry=>
          {:id=>entry_id,
          :elapsed=>10,
          :lastTick=>"2012-12-12T00:00:00Z",
          :tag_list=>["a description"],
          :running=>true,
          :current=>true,
          :project=>"a project"}
        }
      )
    end

  end

  context "PUT #update" do

    it "updates an entry" do
      entry = @user.entries.create(tag_list: ["my description"])

      params = {
        tag_list: ["new description"]
      }

      expect {
        put :update, id: entry.id, entry: params, token: @user.token
      }.to change{entry.reload.tag_list}.to(["new description"])

    end

    it "renders the entry" do
      entry = @user.entries.create(tag_list: ["my description"])

      params = {
        tag_list: ["new description"]
      }

      put :update, id: entry.id, entry: params, token: @user.token

      expect(json_response).to eq(
        {:entry=>
          {:id=>entry.id,
          :elapsed=> nil,
          :lastTick=> nil,
          :tag_list=>["new description"],
          :running=>nil,
          :current=>nil,
          :project=>nil}
        }
      )
    end

  end

  context "DELETE #destroy" do
    it "destroys the entry" do
      entry = @user.entries.create(tag_list: ["my description"])

      expect {
        delete :destroy, id: entry.id, token: @user.token
      }.to change{Entry.count}.from(1).to(0)

      expect(json_response).to eq({ status: "success" })
    end
  end

  context "DELETE #index" do
    it "clears all entries that are not running" do
      @user.entries.create(tag_list: ["its running"], running: true)
      @user.entries.create(tag_list: ["my description"])

      expect {
        delete :clear, token: @user.token
      }.to change{Entry.count}.from(2).to(1)

      expect(Entry.first.tag_list).to eq(["its running"])
    end
  end
end
