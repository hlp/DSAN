module ApplicationHelper

# Return title on a per-page basis.
def title
  base_title = "DSAN: DesignScript Archive Network"
  if @title.nil?
    base_title
  else
    "#{base_title} | #{@title}"
  end
end

def logo
  image_tag("logo.png", :alt => "DSAN", :class => "round")
end

def coderay(text)
  CodeRay.scan(text, :java).div(:css => :class)
end

def read_module(filename)
  IO.read(::Rails.root.to_s + '/public/ds_modules/' + filename)
end

end
