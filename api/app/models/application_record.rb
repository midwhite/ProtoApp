class ApplicationRecord < ActiveRecord::Base
  include Constants

  self.abstract_class = true

  def random_str(length)
    o = [("A".."Z"), ("a".."z"), ("0".."9")].map(&:to_a).flatten
    (0...length).map{ o[rand(o.length)] }.join
  end

  def upload_file(s3_key, body)
    s3 = Aws::S3::Resource.new(region: S3_REGION)
    bucket = s3.bucket(ENV["S3_BUCKET_NAME"])
    bucket.put_object(body: body, key: s3_key)
  end

  def response
    {
      id: self.id,
      userId: self.user_id,
      src: self.src_url
    }
  end
end
