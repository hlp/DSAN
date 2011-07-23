class RemoveDsModuleIdFromCategories < ActiveRecord::Migration
  def self.up
    remove_column :categories, :ds_module_id
  end

  def self.down
    add_column :categories, :ds_module_id, :integer
  end
end
