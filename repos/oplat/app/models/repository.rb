class Repository < ActiveRecord::Base
  validates :name, length: { minimum: 3, maximum: 40 }
end
