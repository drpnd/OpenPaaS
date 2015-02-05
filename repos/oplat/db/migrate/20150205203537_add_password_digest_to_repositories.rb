class AddPasswordDigestToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :password_digest, :string
  end
end
