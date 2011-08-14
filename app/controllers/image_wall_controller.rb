class ImageWallController < ApplicationController
  def index
    @images = []
    DsModule.all.each do |dsm|
      dsm.module_files.each do |file|
        @images.push(absolute_path_to_web_path(file.path)) if file.is_image?
      end
    end
  end

end
