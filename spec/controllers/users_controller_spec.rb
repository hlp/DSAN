require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      @module_attr = {
        :name => "Test Module",
        :version => "1.0",
        :documentation => "It works",
        :example => "1 + 1 = 2",
        :files => "bundle_tower_07.ds"
      }
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "profile_image")
    end

    it "should show the user's ds modules" do
      m1 = Factory(:ds_module, :user => @user, :name => "Module 1")
      m2 = Factory(:ds_module, :user => @user, :name => "Module 2")
      get :show, :id => @user
      response.should have_selector("span.content", :content => m1.name)
      response.should have_selector("span.content", :content => m2.name)
    end

  end # GET show

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end # end GET new

  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the Picture"

  end # end GET edit
  
  describe "GET 'index'" do

    describe "for non-signed-in users" do

      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end

    end # non signed in users

    
    describe "for signed-in users" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        second = Factory(:user, :email => "another@example.com")
        third = Factory(:user, :email => "another@example.net")

        @users = [@user, second, third]
      end

      # this has been acting very strange, failing when it shouldn't
      it "should be successful" do
        get :index
        response.should be_success
        #true
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")        
      end


      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("span", :content => user.name)
        end
      end

    end # signed in users
    

  end # GET index


  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
          :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

    end

    describe "success" do
      before(:each) do
        Factory(:ds_module)
        @attr = { :name => "New User", :email => "user@example.com",
          :password => "foobar", :password_confirmation => "foobar",
          :access_code => "acode",
          :ds_attachment => File.new(Rails.root + 'spec/fixtures/scripts/hello.ds') }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to DSAN/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

    end # end describe success

  end # end POST tests

  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      
      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
          :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end

    end # end describe failure

    describe "success" do

      before(:each) do
        @attr = { :name => "New Name", :email => "user@example.org",
          :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end

    end # describe success

  end # end PUT update tests

  describe "authentication of edit/update pages" do
    
    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end

    end # non-signed in users

    describe "for signed in users" do

      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end

    end # signed in users


  end # authentication of edit update pages


end
