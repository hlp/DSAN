
require 'image_size'

class ImageWallController < ApplicationController
  def index
    @images = []

    DsModule.all.each do |dsm|
      dsm.module_files.each do |file|
        image_details = [absolute_path_to_web_path(file.path), dsm]
        @images.push(image_details) if file.is_image?
      end
    end
  end

  private

  # I thought this was needed but it actually wasn't
  # get the image dimensions and convert them to masonry sizes
  def get_image_dims(image_path) 
    
    # find the image's native dimensions
    img_size = ImageSize.new(IO.read(image_path))

    if (img_size.get_width == nil || img_size.get_height == nil)
      return [0, 0]
    end

    # TODO: this also exists in the CSS as "col3", it should only appear once
    target_width = 280

    new_height = target_width.to_f / img_size.get_width * img_size.get_height

    return [target_width, new_height.to_i]
  end

end
