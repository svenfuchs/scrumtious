require File.dirname(__FILE__) + '/../spec_helper'

describe ReleasesController, "GET #show" do
  act! { get :show, :id => 1 }

  before do
    @release  = releases(:default)
    Release.stub!(:find).with('1').and_return(@release)
  end

  it_assigns :release
  it_renders :template, :show
end

describe ReleasesController, "GET #new" do
  act! { get :new, :release => {:project_id => @release.project_id} }

  before do
    @project = mock_model Project, :new_record? => false, :errors => []
    @release = Release.new :project_id => @project.id
  end

  it "assigns @release" do
    act!
    assigns[:release].should be_new_record
  end

  it_renders :template, :new
end

describe ReleasesController, "POST #create" do
  before do
    @project = mock_model Project, :new_record? => false, :errors => []
    @release = mock_model Release, :project => @project, :new_record? => false, :errors => []
    @attributes = {'project_id' => @project.id}
    
    Project.stub!(:find).and_return @project
    Release.stub!(:new).with(@attributes).and_return(@release)
  end

  describe ReleasesController, "(successful creation)" do
    act! { post :create, :release => @attributes }

    before do
      @release.stub!(:save).and_return(true)
    end

    it_assigns :release, :flash => { :notice => :not_nil }
    it_redirects_to { release_path(@release) }
  end

  describe ReleasesController, "(unsuccessful creation)" do
    act! { post :create, :release => @attributes }
  
    before do
      @release.stub!(:save).and_return(false)
    end
  
    it_assigns :release
    it_renders :template, :new
  end
end

describe ReleasesController, "GET #edit" do
  act! { get :edit, :id => 1 }

  before do
    @release  = releases(:default)
    Release.stub!(:find).with('1').and_return(@release)
  end

  it_assigns :release
  it_renders :template, :edit
end

describe ReleasesController, "PUT #update" do
  before do
    @attributes = {}
    @release = releases(:default)
    Release.stub!(:find).with('1').and_return(@release)
  end

  describe ReleasesController, "(successful save)" do
    act! { put :update, :id => 1, :release => @attributes }

    before do
      @release.stub!(:save).and_return(true)
    end

    it_assigns :release, :flash => { :notice => :not_nil }
    it_redirects_to { release_path(@release) }
  end

  describe ReleasesController, "(unsuccessful save)" do
    act! { put :update, :id => 1, :release => @attributes }

    before do
      @release.stub!(:save).and_return(false)
    end

    it_assigns :release
    it_renders :template, :edit
  end
end

describe ReleasesController, "DELETE #destroy" do
  act! { delete :destroy, :id => 1 }

  before do
    @release = releases(:default)
    @release.stub!(:destroy)
    Release.stub!(:find).with('1').and_return(@release)
  end

  it_assigns :release
  it_redirects_to { project_path(@release.project) }
end