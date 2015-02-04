class AddIndexToRepositories < ActiveRecord::Migration
  def change
    add_index :repositories, [:user_id, :name]
  end
end
