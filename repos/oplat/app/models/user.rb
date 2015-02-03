class User < ActiveRecord::Base
  validates :name, length: { minimum: 5, maximum: 40 }
end
