class User < ActiveRecord::Base
  has_many :repositories
  validates :name, presence: true, length: { minimum: 5, maximum: 40 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
end
