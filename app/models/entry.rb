class Entry < ActiveRecord::Base
  belongs_to :user, inverse_of: :entries
end
