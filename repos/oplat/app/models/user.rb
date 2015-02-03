class User < ActiveRecord::Base
  has_many :repositories
  validates :name, length: { minimum: 5, maximum: 40 }
end
