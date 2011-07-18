class AddCategoryToDsModule < ActiveRecord::Migration
  def self.up
    add_column :ds_modules, :category, :string
  end

  def self.down
    remove_column :ds_modules, :category
  end
end
