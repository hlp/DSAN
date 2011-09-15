class StatusController < ApplicationController
  def index
    strs = `df -h`.split(" ")
    line_1 = strs[0,6].join(" ")
    line_2 = strs[8, 6].join(" ")
    @status_string = line_1 + "<br />" + line_2
  end

end
