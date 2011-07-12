class CreateDsModules < ActiveRecord::Migration
  def self.up
    create_table :ds_modules do |t|
      t.integer :user_id
      t.string :name
      t.string :version
      t.text :documentation
      t.text :example
      t.text :files

      t.timestamps
    end
  end

  def self.down
    drop_table :ds_modules
  end
end
