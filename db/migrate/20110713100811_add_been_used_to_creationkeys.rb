class AddBeenUsedToCreationkeys < ActiveRecord::Migration
  def self.up
    add_column :creationkeys, :been_used, :boolean
  end

  def self.down
    remove_column :creationkeys, :been_used
  end
end
