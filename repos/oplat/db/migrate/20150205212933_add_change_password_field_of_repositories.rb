class AddChangePasswordFieldOfRepositories < ActiveRecord::Migration
  def change
    rename_column :repositories, :password_digest, :db_password
  end
end
