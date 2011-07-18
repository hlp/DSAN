class CreateModuleFiles < ActiveRecord::Migration
  def self.up
    create_table :module_files do |t|
      t.string :type
      t.string :path

      t.timestamps
    end
  end

  def self.down
    drop_table :module_files
  end
end
