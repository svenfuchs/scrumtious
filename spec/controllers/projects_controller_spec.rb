require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController, "GET #index" do
  act! { get :index }

  before do
    @projects = []
    Project.stub!(:find).with(:all).and_return(@projects)
  end
  
  it_assigns :projects
  it_renders :template, :index
end

describe ProjectsController, "GET #show" do
  act! { get :show, :id => 1 }

  before do
    @project = Factory :scrumtious
    Project.stub!(:find).and_return(@project)
  end
  
  it_assigns :project
  it_renders :template, :show
end

describe ProjectsController, "GET #new" do
  act! { get :new }
  before do
    @project  = Project.new
  end

  it "assigns @project" do
    act!
    assigns[:project].should be_new_record
  end
  
  it_renders :template, :new
end

describe ProjectsController, "POST #create" do
  before do
    @attributes = {}
    @project = mock_model Project, :new_record? => false, :errors => []
    Project.stub!(:new).with(@attributes).and_return(@project)
  end
  
  describe ProjectsController, "(successful creation)" do
    act! { post :create, :project => @attributes }

    before do
      @project.stub!(:save).and_return(true)
    end
    
    it_assigns :project, :flash => { :notice => :not_nil }
    it_redirects_to { project_path(@project) }
  end

  describe ProjectsController, "(unsuccessful creation)" do
    act! { post :create, :project => @attributes }

    before do
      @project.stub!(:save).and_return(false)
    end
    
    it_assigns :project
    it_renders :template, :new
  end
end

describe ProjectsController, "GET #edit" do
  act! { get :edit, :id => 1 }
  
  before do
    @project = Factory :scrumtious
    Project.stub!(:find).and_return(@project)
  end

  it_assigns :project
  it_renders :template, :edit
end

describe ProjectsController, "PUT #update" do
  before do
    @attributes = {}
    @project = Factory :scrumtious
    Project.stub!(:find).and_return(@project)
  end
  
  describe ProjectsController, "(successful save)" do
      act! { put :update, :id => 1, :project => @attributes }

    before do
      @project.stub!(:save).and_return(true)
    end
    
    it_assigns :project, :flash => { :notice => :not_nil }
    it_redirects_to { project_path(@project) }
  end

  describe ProjectsController, "(unsuccessful save)" do
      act! { put :update, :id => 1, :project => @attributes }

    before do
      @project.stub!(:save).and_return(false)
    end
    
    it_assigns :project
    it_renders :template, :edit
  end
end

describe ProjectsController, "DELETE #destroy" do
  act! { delete :destroy, :id => 1 }
  
  before do
    @project = Factory :scrumtious
    @project.stub!(:destroy)
    Project.stub!(:find).and_return(@project)
  end

  it_assigns :project
  it_redirects_to { projects_path }
end