require File.dirname(__FILE__) + '/../spec_helper'

describe SprintsController, "GET #show" do
  act! { get :show, :id => 1 }

  before do
    @sprint  = milestones(:sprint_1)
    Sprint.stub!(:find).with('1').and_return(@sprint)
  end
  
  it_assigns :sprint
  it_renders :template, :show
end

describe SprintsController, "GET #new" do
  act! { get :new }
  before do
    @release = mock_model Release, :new_record? => false, :errors => []
    @sprint  = Sprint.new :release_id => @release.id
  end

  it "assigns @sprint" do
    act!
    assigns[:sprint].should be_new_record
  end
  
  it_renders :template, :new
end

describe SprintsController, "POST #create" do
  before do
    @project = mock_model Project, :new_record? => false, :errors => []
    @release = mock_model Release, :project => @project, :new_record? => false, :errors => []
    @sprint = mock_model Sprint, :project => @project, :release => @release, :new_record? => false, :errors => []
    @attributes = {'release_id' => @release.id}
    
    Release.stub!(:find).and_return @release
    Sprint.stub!(:new).with(@attributes).and_return(@sprint)
  end
  
  describe SprintsController, "(successful creation)" do
    act! { post :create, :sprint => @attributes }

    before do
      @sprint.stub!(:save).and_return(true)
    end
    
    it_assigns :sprint, :flash => { :notice => :not_nil }
    it_redirects_to { sprint_path(@sprint) }
  end

  describe SprintsController, "(unsuccessful creation)" do
    act! { post :create, :sprint => @attributes }

    before do
      @sprint.stub!(:save).and_return(false)
    end
    
    it_assigns :sprint
    it_renders :template, :new
  end
end

describe SprintsController, "GET #edit" do
  act! { get :edit, :id => 1 }
  
  before do
    @sprint  = milestones(:sprint_1)
    Sprint.stub!(:find).with('1').and_return(@sprint)
  end

  it_assigns :sprint
  it_renders :template, :edit
end

describe SprintsController, "PUT #update" do
  before do
    @attributes = {}
    @sprint = milestones(:sprint_1)
    Sprint.stub!(:find).with('1').and_return(@sprint)
  end
  
  describe SprintsController, "(successful save)" do
    act! { put :update, :id => 1, :sprint => @attributes }

    before do
      @sprint.stub!(:save).and_return(true)
    end
    
    it_assigns :sprint, :flash => { :notice => :not_nil }
    it_redirects_to { sprint_path(@sprint) }
  end

  describe SprintsController, "(unsuccessful save)" do
    act! { put :update, :id => 1, :sprint => @attributes }

    before do
      @sprint.stub!(:save).and_return(false)
    end
    
    it_assigns :sprint
    it_renders :template, :edit
  end
end

describe SprintsController, "DELETE #destroy" do
  act! { delete :destroy, :id => 1 }
  
  before do
    @sprint = milestones(:sprint_1)
    @sprint.stub!(:destroy)
    Sprint.stub!(:find).with('1').and_return(@sprint)
  end

  it_assigns :sprint
  it_redirects_to { release_path(@sprint.release) }
end