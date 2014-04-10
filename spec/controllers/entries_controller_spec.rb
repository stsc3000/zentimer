require 'spec_helper'

describe EntriesController do
  render_views

  let(:user){ User.create }

  context "GET #index" do
    let!(:entry) { user.entries.create }
    let!(:old_entry) { user.entries.create.tap { |e| e.update_column :updated_at, Time.now - 4.years } }
    it "gets all the users entries of today" do
      get :index, token: user.token
      expect(json_response).to eq(
        {:entries=>
          [{:id=>entry.id,
            :elapsed=>nil,
            :lastTick=>nil,
            :tag_list=>[],
            :running=>nil,
            :current=>nil,
            :project=>nil,
            :description=>nil,
            :logged_at=>nil}
          ]
        })
    end
    it 'gets the current entry, too' do
      old_entry.update_attributes current: true, running: true
      get :index, token: user.token
      expect(json_response).to eq(
        {:entries=>
          [{:id=>entry.id,
            :elapsed=>nil,
            :lastTick=>nil,
            :tag_list=>[],
            :running=>nil,
            :current=>nil,
            :project=>nil,
            :description=>nil,
            :logged_at=>nil
          },

          {:id=>old_entry.id,
            :elapsed=>nil,
            :lastTick=>nil,
            :tag_list=>[],
            :running=>true,
            :current=>true,
            :project=>nil,
            :description=>nil,
            :logged_at=>nil
          }
          ]
        })

    end
  end

  context "GET #show" do
    it "gets a specific entry" do
      entry = user.entries.create
      get :show, id: entry.id, token: user.token
      expect(json_response).to eq(
        {
          entry: {:id=>entry.id,
                  :elapsed=>nil,
                  :lastTick=>nil,
                  :tag_list=>[],
                  :running=>nil,
                  :current=>nil,
                  :project=>nil,
                  :description=>nil,
                  :logged_at=>nil}
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
        :project=>"a project",
        :description=>"things I did"
      }
      expect{
        post :create, entry: params, token: user.token
      }.to change{Entry.count}
    end

    it "renders the created entry" do
      params = {
        :elapsed=>10,
        :lastTick=>"2012-12-12",
        :tag_list=>["a description"],
        :running=>true,
        :current=>true,
        :project=>"a project",
        :description=>"things I did"
      }
      post :create, entry: params, token: user.token
      entry_id = assigns(:entry).id
      expect(json_response).to eq(
        {:entry=>
          {:id=>entry_id,
          :elapsed=>10,
          :lastTick=>"2012-12-12T00:00:00Z",
          :tag_list=>["a description"],
          :running=>true,
          :current=>true,
          :project=>"a project",
          :description=>"things I did",
          :logged_at=>"2012-12-12"}
        }
      )
    end

  end

  context "PUT #update" do

    it "updates an entry" do
      entry = user.entries.create(tag_list: ["my description"])

      params = {
        tag_list: ["new tag"]
      }

      expect {
        put :update, id: entry.id, entry: params, token: user.token
      }.to change{entry.reload.tag_list}.to(["new tag"])

    end

    it "renders the entry" do
      entry = user.entries.create(tag_list: ["my description"])

      params = {
        tag_list: ["new tag"]
      }

      put :update, id: entry.id, entry: params, token: user.token

      expect(json_response).to eq(
        {:entry=>
          {:id=>entry.id,
          :elapsed=> nil,
          :lastTick=> nil,
          :tag_list=>["new tag"],
          :running=>nil,
          :current=>nil,
          :project=>nil,
          :description=>nil,
          :logged_at=>nil}
        }
      )
    end

  end

  context "DELETE #destroy" do
    it "destroys the entry" do
      entry = user.entries.create(tag_list: ["my description"])

      expect {
        delete :destroy, id: entry.id, token: user.token
      }.to change{Entry.count}.from(1).to(0)

      expect(json_response).to eq({ status: "success" })
    end
  end

  context "DELETE #index" do
    it "clears all entries that are not running" do
      user.entries.create(tag_list: ["its running"], running: true)
      user.entries.create(tag_list: ["my description"])

      expect {
        delete :clear, token: user.token, ids: user.entries.map(&:id)
      }.to change{Entry.count}.from(2).to(1)

      expect(Entry.first.tag_list).to eq(["its running"])
    end
  end

  context "GET #filter" do
    let(:another_user){ User.create }
    let!(:an_entry) do
      Entry.create(tag_list: ["work", "coffee"], project: "Important Project", user: user).tap do |entry|
        entry.update_column :updated_at,  Time.zone.parse("2012-1-1")
      end
    end
    let!(:another_entry) do
      Entry.create(tag_list: ["work", "tea"], project: "Some Other Project", user: user).tap do |entry|
        entry.update_column :updated_at,  Time.zone.parse("2012-1-2")
      end
    end
    let!(:entry_by_someone_else) do
      Entry.create(tag_list: ["work", "tea"], project: "Some Other Project", user: another_user).tap do |entry|
        entry.update_column :updated_at,  Time.zone.parse("2012-1-1")
      end
    end
    let(:query) do 
      {
        date_filter: {
          from: Time.zone.parse('2012-1-1').beginning_of_day.iso8601,
          to: Time.zone.parse('2012-1-1').end_of_day.iso8601
        },
        tags: {
          include: ["work"]
        },
        projects: ["Important Project"]
      }
    end 

    it "filters all entries by given params" do

      get :filter, token: user.token, query: query

      entries = assigns :entries
      expect(entries).to include(an_entry)
      expect(entries).not_to include(another_entry)
      expect(entries).not_to include(entry_by_someone_else)

    end

    it "filtes all entries and returns json" do
      get :filter, token: user.token, query: query
      expected_response = { 
        :entries=>
          [
            {
              :id=>an_entry.id,
              :elapsed=>nil,
              :lastTick=>nil,
              :tag_list=>["work", "coffee"],
              :running=>nil,
              :current=>nil,
              :description=>nil,
              :project=>"Important Project"
            }
          ]
      }

    end

  end
end
