require 'spec_helper'

describe Entry do
  describe "scoping" do
    it "fetches entries from today" do
      today_entry = Entry.create

      tomorrow_entry = Entry.create.tap do |entry|
        entry.update_column :updated_at, (Time.now + 1.day).beginning_of_day
      end

      yesterday_entry = Entry.create.tap do |entry|
        entry.update_column :updated_at, (Time.now - 1.day).beginning_of_day
      end

      entries = Entry.today
      expect(entries).to include(today_entry)
      expect(entries).not_to include(tomorrow_entry)
      expect(entries).not_to include(yesterday_entry)
    end

    it "fetches entries from this week" do
      this_week_entry = Entry.create

      next_week_entry = Entry.create.tap do |entry|
        entry.update_column :updated_at, (Time.now + 7.day).beginning_of_day
      end

      last_week_entry = Entry.create.tap do |entry|
        entry.update_column :updated_at, (Time.now - 7.day).beginning_of_day
      end

      entries = Entry.this_week
      expect(entries).to include(this_week_entry)
      expect(entries).not_to include(next_week_entry)
      expect(entries).not_to include(last_week_entry)
    end

    it "fetches entries from this month" do
      today_entry = Entry.create

      next_month_entry = Entry.create.tap do |entry|
        end_of_month = Time.now.end_of_month + 1.day
        entry.update_column :updated_at, end_of_month
      end

      last_month_entry = Entry.create.tap do |entry|
        start_of_month = Time.now.beginning_of_month - 1.day
        entry.update_column :updated_at, start_of_month
      end

      entries = Entry.this_month
      expect(entries).to include(today_entry)
      expect(entries).not_to include(next_month_entry)
      expect(entries).not_to include(last_month_entry)
    end

    it "fetches arbitrary start and end dates" do
      today_entry = Entry.create

      in_two_days_entry = Entry.create.tap do |entry|
        entry.update_column :updated_at, Time.now + 2.days
      end

      two_days_ago_entry = Entry.create.tap do |entry|
        entry.update_column :updated_at, Time.now - 2.days
      end

      entries = Entry.between(Time.now - 1.days, Time.now + 1.days)
      expect(entries).to include(today_entry)
      expect(entries).not_to include(in_two_days_entry)
      expect(entries).not_to include(two_days_ago_entry)
    end

    it "fetches entries by projects" do
      the_entry = Entry.create(project: "THE project")
      another_entry = Entry.create(project: "another project")

      entries = Entry.by_project("THE project")
      expect(entries).to include(the_entry)
      expect(entries).not_to include(another_entry)
    end

    it "fetches entries by multiple projects" do
      the_entry = Entry.create(project: "THE project")
      another_entry = Entry.create(project: "another project")

      entries = Entry.by_project(["THE project", "another project"])
      expect(entries).to include(the_entry)
      expect(entries).to include(another_entry)
    end

    it "fetches entries by any matching tags" do
      the_entry = Entry.create(tag_list: ["the tag"])
      another_entry = Entry.create(tag_list: ["another tag"])

      entries = Entry.by_tags(["the tag", "some other tag"])

      expect(entries).to include(the_entry)
      expect(entries).not_to include(another_entry)
    end

    it "fetches all entries if no tags are provided" do
      the_entry = Entry.create(tag_list: ["the tag"])
      another_entry = Entry.create(tag_list: ["another tag"])

      entries = Entry.by_tags([])

      expect(entries).to include(the_entry)
      expect(entries).to include(another_entry)

    end

  end
end
