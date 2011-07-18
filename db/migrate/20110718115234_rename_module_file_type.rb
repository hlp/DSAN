class RenameModuleFileType < ActiveRecord::Migration
  def self.up
    rename_column :module_files, :type, :file_type
  end

  def self.down
    rename_column :module_files, :file_type, :type
  end
end
