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
  scope :current, -> { where( current: true ) }

  scope :by_projects, ->(projects) do
    where(project: Array(projects)) if projects.present?
  end

  scope :with_tags, ->(tags) do 
    scoped = all
    scoped = scoped.tagged_with(Array(tags[:include])) if tags[:include].present?
    scoped = scoped.tagged_with(Array(tags[:exclude]), exclude: true) if tags[:exclude].present?
    scoped
  end

  scope :filter, ->(options) do
    between(options[:date_filter][:from], options[:date_filter][:to])
      .by_projects(options[:projects])
      .with_tags(options[:tags])
  end

  scope :unique_projects, ->{ select(:project).order("project ").uniq }

  scope :tags, ->{ select( "tags.name" ).joins(:tags).order("tags.name").uniq }

end
