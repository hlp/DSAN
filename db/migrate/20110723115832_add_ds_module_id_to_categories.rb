class AddDsModuleIdToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :ds_module_id, :integer
  end

  def self.down
    remove_column :categories, :ds_module_id
  end
end
