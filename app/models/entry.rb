class Entry < ActiveRecord::Base
  belongs_to :user, inverse_of: :entries
  serialize :description, Array
end
