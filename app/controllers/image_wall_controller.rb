
class ImageWallController < ApplicationController
  def index
    @images = []

    DsModule.all.each do |dsm|
      dsm.module_files.each do |file|
        image_details = [file.web_path, dsm]
        @images.push(image_details) if file.is_image?
      end
    end
  end

end
