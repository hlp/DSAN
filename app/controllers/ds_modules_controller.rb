
class DsModulesController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @title = "All modules"
    @ds_modules = DsModule.all
  end

  def show
    @ds_module = DsModule.find(params[:id])
    @title = @ds_module.name
  end

  def new
    @ds_module = DsModule.new
    @title = "Create DesignScript Module"
  end

  def create
    @ds_module = current_user.ds_modules.build(params[:ds_module])
    if @ds_module.save
      @ds_module.setup
      flash[:success] = "Module created!"
      redirect_to @ds_module
    else
      render 'new'
    end
  end

  def edit
    @title = "Edit module"
  end

  def update
    @ds_module = DsModule.find(params[:id])
    if @ds_module.update_attributes(params[:ds_module])
      @ds_module.setup
      flash[:success] = "Module updated."
      redirect_to @ds_module
    else
      @title = "Edit module"
      render 'edit'
    end
  end

  def destroy
  end

  private 

  def correct_user
    @ds_module = DsModule.find(params[:id])
    redirect_to(root_path) unless current_user?(@ds_module.user)
  end

end
