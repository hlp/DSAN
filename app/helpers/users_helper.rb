module UsersHelper

  def image_for(user, image_size = 100)
    image_tag("default_profile_large.jpeg", :alt => user.name,
              :class => "profile_image", 
              :size => "#{image_size}x#{image_size}")
  end

end
