require 'spec_helper'

describe DsModulesController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end

  end # access control

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
      end

      it "should not create a micropost" do
        lambda do
          post :create, :ds_module => @attr
        end.should_not change(DsModule, :count)
      end

      it "should rendder the home page" do
        post :create, :ds_module => @attr
        response.should render_template('pages/home')
      end

    end # describe failure

    describe "success" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @attr = {
          :name => "Test Module",
          :version => "1.0",
          :documentation => "It works",
          :example => "1 + 1 = 2",
          :files => "bundle_tower_07.ds"
        }
      end

      it "should create a micropost" do
        lambda do
          post :create, :ds_module => @attr
        end.should change(DsModule, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :ds_module => @attr
        response.should redirect_to(root_path)
      end
      
      it "should have a flash message" do
        post :create, :ds_module => @attr
        flash[:success].should =~ /Module created/i
      end

    end # describe success

  end # describe POST create

end # DsModulesController
