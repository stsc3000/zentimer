class Entry < ActiveRecord::Base
  belongs_to :user, inverse_of: :entries
  acts_as_ordered_taggable_on :tags

  scope :today, -> { between Time.now.beginning_of_day, Time.now.end_of_day }
  scope :this_week, -> { between Time.now.beginning_of_week, Time.now.end_of_week }
  scope :this_month, -> { between Time.now.beginning_of_month, Time.now.end_of_month  }
  scope :between, ->(from, to) do
      #wtf? no tap?
      scoped = all
      scoped = scoped.where("updated_at >= ?", from) if from
      scoped = scoped.where("updated_at <= ?", to ) if to
      scoped
  end

  scope :by_projects, ->(projects) do
    where(project: Array(projects)) if projects.present?
  end

  scope :by_tags, ->(tags) do 
    tagged_with(Array(tags), any: true) if tags.present?
  end

  scope :filter, ->(options) do
    between(options[:date_filter][:from], options[:date_filter][:to])
      #.by_tags(options[:by_tags])
      #.by_projects(options[:by_projects])
  end

end
