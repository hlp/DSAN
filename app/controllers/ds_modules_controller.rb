
class DsModulesController < ApplicationController
  before_filter :authenticate

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
      flash[:success] = "Module created!"
      redirect_to @ds_module
    else
      render 'pages/home'
    end
  end

  def destroy
  end
end
