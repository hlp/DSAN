  def absolute_path_to_web_path(abs_path)
    abs_path.gsub(Rails.root.to_s + "/public", "")
  end
