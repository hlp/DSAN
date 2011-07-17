# == Schema Information
#
# Table name: creationkeys
#
#  id         :integer         not null, primary key
#  key        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Creationkey do

  it "should create a new instance given no attributes" do
    Creationkey.create!()
  end

  it "should create a correct instance given a key" do
    code = "acode"
    specific_key = Creationkey.create( :key => code )
    specific_key.key.should == code
  end


end
