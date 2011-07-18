# == Schema Information
#
# Table name: module_files
#
#  id         :integer         not null, primary key
#  file_type  :string(255)
#  path       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ModuleFile < ActiveRecord::Base
  attr_accessible :file_type, :path

  # Valid types:
  # - script
  # - image
  # - dll
  # - other
  
  validates :path, :presence => true, :length => { :maximum => 240 }

  validate :has_valid_type

  belongs_to :ds_module

  def has_valid_type
    self.file_type = get_file_type
    return true
  end

  def get_file_type
    case File.extname(path)
      when ".ds" then return "script"

      when ".jpg" then return "image"
      when ".jpeg" then return "image"
      when ".png" then return "image"

      when ".dll" then return "dll"
    end

    return "other"
  end

  def base
    return File.basename(self.path)
  end

  def is_image?
    return self.file_type == "image"
  end

  def is_script?
    return self.file_type == "script"
  end

  def is_dll?
    return self.file_type == "dll"
  end

  def is_other?
    return self.file_type == "other"
  end

end
