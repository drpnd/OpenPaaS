class User < ActiveRecord::Base
  has_many :repositories, dependent: :destroy

  before_save { self.name = name.downcase }
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  before_create :create_user

  validates :name, presence: true, length: { minimum: 5, maximum: 40 },
  format: { with: /\A[a-z0-9]+\z/ }, uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def create_user
    `sudo #{Rails.root}/scripts/create_user.rb #{rname.shellescape}`
  end
end
