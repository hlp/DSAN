# == Schema Information
#
# Table name: ds_modules
#
#  id                            :integer         not null, primary key
#  user_id                       :integer
#  name                          :string(255)
#  version                       :string(255)
#  documentation                 :text
#  example                       :text
#  files                         :text
#  created_at                    :datetime
#  updated_at                    :datetime
#  ds_attachment_file_name       :string(255)
#  ds_attachment_content_type    :string(255)
#  ds_attachment_file_size       :integer
#  ds_attachment_updated_at      :datetime
#  category                      :string(255)
#  ds_attachment_last_updated_at :datetime
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
      :files => "bundle_tower_07.ds",
      :tag_list => ["Library"],
      :ds_attachment => File.new(Rails.root + 'spec/fixtures/scripts/hello.ds')
    }
  end

  it "should create a new instance given valid attributes" do
    @ds_module = @user.ds_modules.create!(@attr)
    @ds_module.setup.should be_true
  end

  it "should create ModuleFiles based on an uploaded zip" do
    lambda do
      @ds_module = @user.ds_modules.create!(@attr.merge(
        :ds_attachment => File.new(Rails.root + 'spec/fixtures/zips/foobar.zip')))
      @ds_module.setup
    end.should change(ModuleFile, :count).by(3)
  end

  describe "user associations" do
    
    before(:each) do
      @ds_module = @user.ds_modules.create(@attr)
      @ds_module.setup
    end

    it "should have the right associated user" do
      @ds_module.user_id.should == @user.id
      @ds_module.user.should == @user
    end

  end # user associations

  describe "validations" do

    before(:each) do
      @attr = {
        :name => "Test Module",
        :version => "1.0",
        :documentation => "It works",
        :example => "1 + 1 = 2",
        :files => "bundle_tower_07.ds",
        :category => "Library",
        :ds_attachment => File.new(Rails.root + 'spec/fixtures/scripts/hello.ds')
      }
    end

    it "should require a user id" do
      DsModule.new(@attr).should_not be_valid
    end

    it "should require a nonblank name" do
      @user.ds_modules.build(@attr.merge(:name => " ")).should_not be_valid
    end

    it "should reject long content" do
      @user.ds_modules.build(@attr.merge(:name => "a" * 144)).should_not be_valid
    end

    it "should require a nonblank version" do
      @user.ds_modules.build(@attr.merge(:version => " ")).should_not be_valid
    end

    it "should require a nonblank documentation" do
      @user.ds_modules.build(@attr.merge(:documentation => " ")).should_not be_valid
    end

    it "should require a nonblank example" do
      @user.ds_modules.build(@attr.merge(:example => " ")).should_not be_valid
    end

    it "should accept a blank category on Examples" do
      @user.ds_modules.build(@attr.merge(:example => "" , :tag_list => ["Example"])).should be_valid
    end

    # probably not needed as I have control over categories
    it "should reject long categories" 
      # @user.ds_modules.build(@attr.merge(:example => "123", :tag_list => ["a" * 250])).should_not be_valid
    


    it "should require a nonblank category" do
      @user.ds_modules.build(@attr.merge(:tag_list => [])).should_not be_valid
    end


  end # validations


end
