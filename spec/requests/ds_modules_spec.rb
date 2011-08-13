require 'spec_helper'

describe "DsModules" do

  describe "create_module" do

    before(:each) do
      user = Factory(:user)
      visit signin_path
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      click_button
    end

    describe "failure" do

      it "should not make a new ds_module" do
        lambda do
          visit create_module_path
          fill_in "Name", :with => ""
          fill_in "Version", :with => ""
          # webrat is lame and can't find 'Description'
          fill_in "ds_module_documentation", :with => ""
          fill_in "Example", :with => ""
          click_button
          response.should render_template('ds_modules/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(DsModule, :count)
      end

    end # failure

    describe "success" do

      it "should make a new module"

      # I can't figure out a way to make this pass since Webrat can't upload files

      #it "should make a new module" do
      #  lambda do
      #    visit create_module_path
      #    fill_in "Name", :with => "New Module"
      #    fill_in "Version", :with => "1.0"
      #    fill_in "ds_module_documentation", :with => "Very good."
      #    fill_in "Example", :with => "1+1=2"
          # upload file
      #    click_button
      #    response.should have_selector("div.flash.success",
      #                                  :content => "Module created")
      #    response.should render_template('ds_modules/show')
      #   
      #    end.should_not change(DsModule, :count)
      
    end # success

  end # creation


end # DsModules
