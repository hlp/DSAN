# == Schema Information
#
# Table name: creationkeys
#
#  id         :integer         not null, primary key
#  key        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Creationkey < ActiveRecord::Base
  after_initialize :init

  def init
    self.key ||= ('a'..'z').to_a.shuffle[0...5].join
  end

end
