# == Schema Information
#
# Table name: module_files
#
#  id           :integer         not null, primary key
#  file_type    :string(255)
#  path         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  ds_module_id :integer
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
    case File.extname(path).downcase
      when ".ds" then return "script"

      when ".jpg" then return "image"
      when ".jpeg" then return "image"
      when ".png" then return "image"

      when ".dll" then return "dll"
    end

    return "other"
  end

  def absolute_path
    Rails.public_path + "/" + path
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

  # TODO: determine if this is the right convention. Mischa?
  # TODO: fix this hack
  def web_path
    # 47 char is "/"
    return path[0] == 47 ? path : "/" + path
  end

  def get_width
    return nil unless is_image?

    return get_image_dims(path)[0]
  end

  def get_height
    return nil unless is_image?

    return get_image_dims(path)[1]
  end

  def is_width_max?
    dims = get_image_dims(absolute_path)
    return dims[0] > dims[1]
  end

  def get_image_dims(image_path) 
    return nil unless is_image?

    # find the image's native dimensions
    img_size = ImageSize.new(IO.read(image_path))

    if (img_size.get_width == nil || img_size.get_height == nil)
      return nil
    end

    return img_size.get_size
  end


end
