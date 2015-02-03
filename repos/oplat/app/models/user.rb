class User < ActiveRecord::Base
  has_many :repositories
  validates :name, presence: true, length: { minimum: 5, maximum: 40 },
  uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }

  before_save { self.name = email.downcase }
  before_save { self.email = email.downcase }
end
