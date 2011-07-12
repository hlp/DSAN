# == Schema Information
#
# Table name: ds_modules
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  name          :string(255)
#  version       :string(255)
#  documentation :text
#  example       :text
#  files         :text
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe DsModule do
  
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :name => "Test Module",
      :version => "1.0",
      :documentation => "It works",
      :example => "1 + 1 = 2",
      :files => "bundle_tower_07.ds"
    }
  end

  it "should create a new instance given valid attributes" do
    @user.ds_modules.create!(@attr)
  end

  describe "user associations" do
    
    before(:each) do
      @ds_module = @user.ds_modules.create(@attr)
    end

    it "should have the right associated user" do
      @ds_module.user_id.should == @user.id
      @ds_module.user.should == @user
    end

  end # user associations

  describe "validations" do

    it "should require a user id" do
      DsModule.new(@attr).should_not be_valid
    end

    it "should require a nonblank name" do
      @user.ds_modules.build(:name => " ").should_not be_valid
    end

    it "should reject long content" do
      @user.ds_modules.build(:name => "a" * 144).should_not be_valid
    end

    it "should require a nonblank version"

    it "should require a nonblank documentation"

    it "should require a nonblank example"

    it "should require a nonblank file name"


  end # validotions

end
