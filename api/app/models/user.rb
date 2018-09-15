class User < ApplicationRecord
  enum gender: [:male, :female, :x_gender]

  acts_as_paranoid

  has_many :photos, class_name: "UserPhoto", dependent: :destroy
  has_many :notifications, dependent: :destroy

  before_create :set_access_token

  def dummy_email
    "#{self.uid}@#{self.provider}.com"
  end

  def upload_photo(**params)
    photo = self.photos.new
    photo.upload(params)
    photo.save
  end

  private
  def set_access_token
    self.access_token ||= Devise.friendly_token(32)
  end
end
