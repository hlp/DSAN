# == Schema Information
#
# Table name: ds_modules
#
#  id                         :integer         not null, primary key
#  user_id                    :integer
#  name                       :string(255)
#  version                    :string(255)
#  documentation              :text
#  example                    :text
#  files                      :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  ds_attachment_file_name    :string(255)
#  ds_attachment_content_type :string(255)
#  ds_attachment_file_size    :integer
#  ds_attachment_updated_at   :datetime
#

class DsModule < ActiveRecord::Base
  attr_accessible :name, :version, :documentation, :example, :files, :ds_attachment

  has_attached_file :ds_attachment

  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  validates :version, :presence => true, :length => { :maximum => 140 }
  validates :documentation, :presence => true
  validates :example, :presence => true
  #validates :files, :presence => true
  validates_attachment_presence :ds_attachment

  default_scope :order => 'ds_modules.created_at DESC'

  def attachment_is_ds_file?
    File.extname(ds_attachment.path) == ".ds"
  end

end
