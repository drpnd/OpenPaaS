class Repository < ActiveRecord::Base
  belongs_to :user
  validates :name, length: { minimum: 3, maximum: 40 }, format: { with: /\A[A-Za-z0-9]+\z/ }
  validates :user_id, presence: true
  default_scope -> { order('created_at DESC') }
end
