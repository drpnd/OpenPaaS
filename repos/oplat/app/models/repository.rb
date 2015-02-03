class Repository < ActiveRecord::Base
  belongs_to :user
  validates :name, length: { minimum: 3, maximum: 40 }
end
