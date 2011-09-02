require 'image_size'

def absolute_path_to_web_path(abs_path)
  abs_path.gsub(Rails.public_path, "")
end

