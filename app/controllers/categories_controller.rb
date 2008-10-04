class CategoriesController < ApplicationController
  before_filter :set_category
  before_filter :set_project

  def new
  end

  def create
    if @category.save
      flash[:notice] = 'Category has been created.'
      redirect_to @category.project
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category has been updated.'
      redirect_to @category.project
    else
      render :action => "edit"
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url
  end
  
  protected
  
    def set_category
      @category = params[:id] ? Category.find(params[:id]) : Category.new(params[:category])
    end
    
    def set_project
      @project = @category.project if @category
    end
end
