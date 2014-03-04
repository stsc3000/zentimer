class Entry < ActiveRecord::Base
  belongs_to :user, inverse_of: :entries
  acts_as_ordered_taggable_on :tags

  scope :today, -> { between Time.now.beginning_of_day, Time.now.end_of_day }
  scope :this_week, -> { between Time.now.beginning_of_week, Time.now.end_of_week }
  scope :this_month, -> { between Time.now.beginning_of_month, Time.now.end_of_month  }
  scope :between, ->(from, to) { where("updated_at >= ?", from).where("updated_at <= ?", to) }

  scope :by_project, ->(projects) { where(project: Array(projects)) }
end
