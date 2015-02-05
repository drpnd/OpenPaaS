class AddSecretTokenToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :secret_token, :string
  end
end
