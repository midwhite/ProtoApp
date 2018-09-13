class User < ApplicationRecord
  enum gender: [:male, :female, :x_gender]

  before_create :set_access_token

  def dummy_email
    "#{self.uid}@#{self.provider}.com"
  end

  private
  def set_access_token
    self.access_token ||= Devise.friendly_token(32)
  end
end
