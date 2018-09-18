class User < ApplicationRecord
  enum gender: [:male, :female, :x_gender]

  acts_as_paranoid

  has_many :photos, class_name: "UserPhoto", dependent: :destroy
  has_many :notifications, dependent: :destroy

  before_create :set_access_token

  def response
    {
      id: self.id,
      name: self.name,
      age: self.age,
      gender: self.gender,
      area: self.area
    }
  end

  def detail
    self.response.merge(
      profile: self.profile
    )
  end

  def me
    self.detail.merge(
      email: self.email,
      provider: self.provider,
      birthday: self.birthday,
      email: self.email,
    )
  end

  def dummy_email
    "#{self.uid}@#{self.provider}.com"
  end

  def age
    return nil if self.birthday.blank?

    date_format = "%Y%m%d"
    (Date.today.strftime(date_format).to_i - (self.birthday).strftime(date_format).to_i) / 10000
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
