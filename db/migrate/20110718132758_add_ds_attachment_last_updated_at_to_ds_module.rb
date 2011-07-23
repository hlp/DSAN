class AddDsAttachmentLastUpdatedAtToDsModule < ActiveRecord::Migration
  def self.up
    add_column :ds_modules, :ds_attachment_last_updated_at, :datetime
  end

  def self.down
    remove_column :ds_modules, :ds_attachment_last_updated_at
  end
end
