require File.dirname(__FILE__) + '/../spec_helper'

describe ReleasesController, "GET #show" do
  act! { get :show, :id => @release.id }

  before do
    @release = Factory(:release_001)
  end

  it_assigns :release
  it_renders :template, :show
end

describe ReleasesController, "GET #new" do
  act! { get :new, :project_id => @release.project_id }

  before do
    @project, @release = Factory(:scrumtious), Factory(:release_001)
  end

  it "assigns @release" do
    act!
    assigns[:release].should be_new_record
  end

  it_renders :template, :new
end

describe ReleasesController, "POST #create" do
  before do
    @project = Factory :scrumtious
    @release = mock_model Release, :project => @project, :new_record? => false, :errors => []
    @attributes = {'project_id' => @project.id}

    Project.stub!(:find).and_return @project
    Release.stub!(:new).and_return @release
  end

  describe "(successful creation)" do
    act! { post :create, :release => @attributes }

    before do
      @release.stub!(:save).and_return(true)
      @release.stub!(:push!)
    end

    it_assigns :release, :flash => { :notice => :not_nil }
    it_redirects_to { release_path(@release) }
    
    it "syncs the release to its remote milestone" do
      @release.should_receive(:push!)
      act!
    end
  end

  describe "(unsuccessful creation)" do
    act! { post :create, :release => @attributes }
  
    before do
      @release.stub!(:save).and_return(false)
    end
  
    it_assigns :release
    it_renders :template, :new
  end
end

describe ReleasesController, "GET #edit" do
  act! { get :edit, :id => @release.id }

  before do
    @release = Factory(:release_001)
  end

  it_assigns :release
  it_renders :template, :edit
end

describe ReleasesController, "PUT #update" do
  before do
    @attributes = {}
    @release = Factory(:release_001)
    Release.stub!(:find).and_return @release
  end

  describe "(successful save)" do
    act! { put :update, :id => @release.id, :release => @attributes }

    before do
      @release.stub!(:save).and_return(true)
      @release.stub!(:push!)
    end

    it_assigns :release, :flash => { :notice => :not_nil }
    it_redirects_to { release_path(@release) }
    
    it "syncs the release to its remote milestone" do
      @release.should_receive(:push!)
      act!
    end
  end

  describe "(unsuccessful save)" do
    act! { put :update, :id => @release.id, :release => @attributes }

    before do
      @release.stub!(:save).and_return(false)
    end

    it_assigns :release
    it_renders :template, :edit
  end
end

describe ReleasesController, "DELETE #destroy" do
  act! { delete :destroy, :id => @release.id }

  before do
    @release = Factory(:release_001)
    @release.stub!(:destroy)
    Release.stub!(:find).and_return @release
  end

  it_assigns :release
  it_redirects_to { project_path(@release.project) }
end