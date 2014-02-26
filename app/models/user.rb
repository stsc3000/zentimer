class User < ActiveRecord::Base
  after_initialize :add_secure_token
  has_many :entries, dependent: :destroy, inverse_of: :user

  validates :token, length: { is: 64 }

  serialize :tags, Array
  serialize :projects, Array

  private

  def add_secure_token
    self.token ||= SecureRandom.hex(32)
  end

end
