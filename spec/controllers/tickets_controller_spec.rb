require File.dirname(__FILE__) + '/../spec_helper'

describe TicketsController, "GET #show" do
  act! { get :show, :id => 1 }

  before do
    @ticket = Factory :ticket
    Ticket.stub!(:find).and_return(@ticket)
  end

  it_assigns :ticket
  it_renders :template, :show
end

describe TicketsController, "GET #new" do
  act! { get :new }
  before do
    @release = mock_model Release, :new_record? => false, :errors => []
    @ticket  = Ticket.new :release_id => @release.id
  end

  it "assigns @ticket" do
    act!
    assigns[:ticket].should be_new_record
  end

  it_renders :template, :new
end

describe TicketsController, "POST #create" do
  before do
    @ticket = mock_model Ticket, :project => Factory(:scrumtious), :release => Factory(:release_001), 
                                 :errors => [], :local? => false
    @attributes = {'release_id' => @ticket.release.id}

    Ticket.stub!(:new).with(@attributes).and_return(@ticket)
  end

  describe "(successful creation)" do
    act! { post :create, :ticket => @attributes }

    before do
      @ticket.stub!(:save).and_return(true)
      @ticket.stub!(:new_record?).and_return false
      @ticket.stub!(:push!)
    end

    it_assigns :ticket, :flash => { :notice => :not_nil }
    it_redirects_to { project_path(@ticket.project) }
    
    it "syncs the ticket to its remote milestone" do
      @ticket.should_receive(:push!)
      act!
    end
  end

  describe "(unsuccessful creation)" do
    act! { post :create, :ticket => @attributes }

    before do
      @ticket.stub!(:save).and_return(false)
    end

    it_assigns :ticket
    it_renders :template, :new
  end
end

describe TicketsController, "GET #edit" do
  act! { get :edit, :id => 1 }

  before do
    @ticket = Factory :ticket
    Ticket.stub!(:find).and_return(@ticket)
  end

  it_assigns :ticket
  it_renders :template, :edit
end

describe TicketsController, "PUT #update" do
  before do
    @attributes = {}
    @ticket = Factory :ticket
    Ticket.stub!(:find).and_return(@ticket)
  end

  describe TicketsController, "(successful save)" do
    act! { put :update, :id => 1, :ticket => @attributes }

    before do
      @ticket.stub!(:save).and_return(true)
      @ticket.stub!(:push!)
    end

    it_assigns :ticket, :flash => { :notice => :not_nil }
    it_redirects_to { ticket_path(@ticket) }
    
    it "syncs the ticket to its remote milestone" do
      @ticket.should_receive(:push!)
      act!
    end
  end

  describe TicketsController, "(unsuccessful save)" do
    act! { put :update, :id => 1, :ticket => @attributes }

    before do
      @ticket.stub!(:save).and_return(false)
    end

    it_assigns :ticket
    it_renders :template, :edit
  end
end

describe TicketsController, "DELETE #destroy" do
  act! { delete :destroy, :id => 1 }

  before do
    @ticket = Factory :ticket, :project => Factory(:scrumtious)
    @ticket.stub!(:destroy)
    Ticket.stub!(:find).and_return(@ticket)
  end

  it_assigns :ticket
  it_redirects_to { project_path(@ticket.project) }
end