class Entry < ActiveRecord::Base
  belongs_to :user, inverse_of: :entries
  acts_as_ordered_taggable_on :tags
end
