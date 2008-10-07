require File.dirname(__FILE__) + '/../spec_helper'

describe ComponentsController, "GET #new" do
  act! { get :new }
  before do
    @component  = Component.new
  end

  it "assigns @component" do
    act!
    assigns[:component].should be_new_record
  end
  
  it_renders :template, :new
end

describe ComponentsController, "POST #create" do
  before do
    @project = mock_model Project, :new_record? => false, :errors => []
    @component = mock_model Component, :project => @project, :new_record? => false, :errors => []
    @attributes = {'project_id' => @project.id}
    Component.stub!(:new).with(@attributes).and_return(@component)
  end
  
  describe ComponentsController, "(successful creation)" do
    act! { post :create, :component => @attributes }

    before do
      @component.stub!(:save).and_return(true)
    end
    
    it_assigns :component, :flash => { :notice => :not_nil }
    it_redirects_to { edit_project_path(@component.project) }
  end
end

describe ComponentsController, "GET #edit" do
  act! { get :edit, :id => 1 }
  
  before do
    @component  = components(:default)
    Component.stub!(:find).with('1').and_return(@component)
  end

  it_assigns :component
  it_renders :template, :edit
end

describe ComponentsController, "PUT #update" do
  before do
    @project = mock_model Project, :new_record? => false, :errors => []
    @component = components(:default)
    @attributes = {:project_id => @project.id}
    Project.stub!(:find).and_return(@project)
    Component.stub!(:find).with('1').and_return(@component)
  end
  
  describe ComponentsController, "(successful save)" do
    act! { put :update, :id => 1, :component => @attributes }

    before do
      @component.stub!(:save).and_return(true)
    end
    
    it_assigns :component, :flash => { :notice => :not_nil }
    it_redirects_to { edit_project_path(@project) }
  end

  describe ComponentsController, "(unsuccessful save)" do
    act! { put :update, :id => 1, :component => @attributes }

    before do
      @component.stub!(:save).and_return(false)
    end
    
    it_assigns :component
    it_renders :template, :edit
  end
end

describe ComponentsController, "DELETE #destroy" do
  act! { delete :destroy, :id => 1 }
  
  before do
    @component = components(:default)
    @component.stub!(:destroy)
    Component.stub!(:find).with('1').and_return(@component)
  end

  it_assigns :component
  it_redirects_to { components_path }
end