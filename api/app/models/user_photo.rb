class UserPhoto < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :filename, presence: true

  acts_as_paranoid

  def s3_path
    "users/#{self.user_id}/photos/#{self.filename}"
  end

  def src_url
    "#{CDN_DOMAIN}/#{self.s3_path}"
  end

  def upload(**args)
    require "open-uri" if args[:url].present?
    body = args[:url] ? open(args[:url]) : args[:file]
    extname = (args[:url] || args[:file].path).match(/\/[^\/]+\.(gif)|(png)|(jpg)|(jpeg)[^\/]/).to_a.find{|str| %w(gif png jpg jpeg).include?(str) }
    self.filename = "#{self.random_str(16)}.#{extname || 'jpg'}"

    self.upload_file(self.s3_path, body)
  end

  def tinify
    require "tinify"
    Tinify.key = ENV["TINIFY_API_KEY"]
    tmp_path = "#{TMP_PHOTOS_DIR}/user#{self.user_id}_#{self.random_str(10)}_#{self.filename}"
    Tinify.from_url(self.src_url).to_file(tmp_path)
    self.upload(url: tmp_path)
    File.delete(tmp_path)
  end
end
