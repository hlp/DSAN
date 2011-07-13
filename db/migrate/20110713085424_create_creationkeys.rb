class CreateCreationkeys < ActiveRecord::Migration
  def self.up
    create_table :creationkeys do |t|
      t.string :key

      t.timestamps
    end
  end

  def self.down
    drop_table :creationkeys
  end
end
