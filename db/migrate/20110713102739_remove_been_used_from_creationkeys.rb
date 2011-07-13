class RemoveBeenUsedFromCreationkeys < ActiveRecord::Migration
  def self.up
    remove_column :creationkeys, :been_used
  end

  def self.down
    add_column :creationkeys, :been_used, :boolean
  end
end
