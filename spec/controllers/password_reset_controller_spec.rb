require 'spec_helper'

describe PasswordResetController do
  render_views

  describe "GET 'new'" do

    it "should be successful" do
      get 'new'
      response.should be_success
    end

  end # GET new

  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user, :email => "patrick.l.tierney+rspec@gmail.com")
      @attr = { :email => "patrick.l.tierney+rspec@gmail.com" }
    end
    
    it "should redirect to the root page" do
      post :create, :password_reset => @attr
      response.should redirect_to(root_path)
    end

  end # POST create

end
