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
    username = name
    lockfile = '/tmp/oplat.lock'
    # Check the argument
    if username.empty?
      $stderr.puts "Empty username"
      return false
    end

    # Working directory
    wd = ENV['OPLAT_OPLAT_GITOLITE_REPOSITORY']
    ENV['HOME'] = ENV['OPLAT_OPLAT_GITOLITE_HOME']

    FileUtils.cd(wd)

    if File.exist?(lockfile)
      $stderr.puts "File is locked"
      return false
    end

    # Lock
    FileUtils.touch(lockfile)

    if File.exist?("keydir/#{username}.pub")
      $stderr.puts "User already exists"
      FileUtils.rm(lockfile)
      return false
    end
    FileUtils.touch("keydir/#{username}.pub")
    `git add keydir/#{username.shellescape}.pub`
    `git commit -m "add #{username.shellescape}" keydir/#{username.shellescape}.pub`
    `git push`

    # Unlock
    FileUtils.rm(lockfile)
  end
end
