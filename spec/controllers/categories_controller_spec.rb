require File.dirname(__FILE__) + '/../spec_helper'

describe CategoriesController, "GET #new" do
  act! { get :new }
  before do
    @category  = Category.new
  end

  it "assigns @category" do
    act!
    assigns[:category].should be_new_record
  end
  
  it_renders :template, :new
end

describe CategoriesController, "POST #create" do
  before do
    @category = Factory :category_1
    @attributes = {'project_id' => @category.project_id}
    Category.stub!(:new).with(@attributes).and_return(@category)
  end
  
  describe "(successful creation)" do
    act! { post :create, :category => @attributes }

    before do
      @category.stub!(:save).and_return(true)
    end
    
    it_assigns :category, :flash => { :notice => :not_nil }
    it_redirects_to { project_path(@category.project) }
  end
end

describe CategoriesController, "GET #edit" do
  act! { get :edit, :id => 1 }
  
  before do
    @category = Factory :category_1
    Category.stub!(:find).and_return(@category)
  end

  it_assigns :category
  it_renders :template, :edit
end

describe CategoriesController, "PUT #update" do
  before do
    @category = Factory :category_1
    Category.stub!(:find).and_return(@category)
    @attributes = {:project_id => @category.project_id}
    
    Project.stub!(:find).and_return(@category.project)
    Category.stub!(:find).and_return(@category)
  end
  
  describe "(successful save)" do
    act! { put :update, :id => 1, :category => @attributes }

    before do
      @category.stub!(:save).and_return(true)
    end
    
    it_assigns :category, :flash => { :notice => :not_nil }
    it_redirects_to { project_path(@category.project) }
  end

  describe "(unsuccessful save)" do
    act! { put :update, :id => 1, :category => @attributes }

    before do
      @category.stub!(:save).and_return(false)
    end
    
    it_assigns :category
    it_renders :template, :edit
  end
end

describe CategoriesController, "DELETE #destroy" do
  act! { delete :destroy, :id => 1 }
  
  before do
    @category = Factory :category_1
    @category.stub!(:destroy)
    Category.stub!(:find).and_return(@category)
  end

  it_assigns :category
  it_redirects_to { categories_path }
end