class TicketsController < ApplicationController
  before_filter :set_ticket
  before_filter :set_project
  
  def show
  end

  def new
  end
  
  def create
    if @ticket.save
      @ticket.push! unless @ticket.local?
      flash[:notice] = 'Ticket has been created.'
      redirect_back_or_default @ticket.project
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @ticket.update_attributes(params[:ticket])
      @ticket.push! unless @ticket.local?
      flash[:notice] = 'Ticket has been updated.'
      redirect_back_or_default @ticket
    else
      render :action => "edit"
    end
  end
  
  def update_all
    if params[:tickets]
      params[:tickets].each{|id, attrs| Ticket.update(id, attrs) }
      head :ok
    else
      # TODO ?
    end
  end

  def destroy
    @ticket.destroy
    redirect_to @ticket.project
  end
  
  protected
  
    def set_ticket
      @ticket = params[:id] ? Ticket.find(params[:id]) : Ticket.new(params[:ticket])
    end
  
    def set_project
      if params[:project_id]
        @project = @ticket.project = Project.find(params[:project_id]) 
      elsif @ticket
        @project = @ticket.project 
      end
    end
end
