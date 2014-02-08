class User < ActiveRecord::Base
  after_initialize :add_secure_token

  validates :token, length: { is: 64 }

  def entries
    read_attribute(:entries) || []
  end

  private

  def add_secure_token
    self.token ||= SecureRandom.hex(32)
  end

end