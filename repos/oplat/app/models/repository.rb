class Repository < ActiveRecord::Base
  belongs_to :user

  validates :name, length: { minimum: 3, maximum: 40 },
  format: { with: /\A[A-Za-z0-9]+\z/ }, :uniqueness => {:scope => :user_id}
  #validate :user_repository_uniqueness
  #uniqueness: { case_sensitive: false }
  validates :user_id, presence: true
  default_scope -> { order('created_at DESC') }

  before_create {|repository|
    repository.secret_token = SecureRandom.hex(64)
    repository.db_password = SecureRandom.base64(15)}

  before_create :create_repository

  def user_repository_uniqueness
    existing_record = Repository.find(:first, :conditions => ["user_id = ? AND name = ?", user_id, name])
    unless existing_record.blank?
      errors.add(:user_id, "has already been saved for this relationship")
    end
  end

  private
  def create_repository
    cmd = "sudo -u '#{ENV['OPLAT_OPLAT_GITOLITE_USER'].shellescape}' #{Rails.root}/scripts/create_repository.rb #{current_user.name.shellescape} #{name.shellescape} #{db_password.shellescape} #{ENV['OPLAT_OPLAT_EXT_DATABASE_NET'].shellescape}"
    logger.info cmd
    system( cmd )
  end

end
