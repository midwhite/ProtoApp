class User < ApplicationRecord
  def dummy_email
    "#{self.uid}@#{self.provider}.com"
  end
end
