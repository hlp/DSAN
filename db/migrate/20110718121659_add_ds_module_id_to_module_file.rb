class AddDsModuleIdToModuleFile < ActiveRecord::Migration
  def self.up
    add_column :module_files, :ds_module_id, :integer
  end

  def self.down
    remove_column :module_files, :ds_module_id
  end
end
