class TicketsController < ApplicationController
  before_filter :set_ticket
  before_filter :set_project
  
  def show
  end
  
  def create
    if @ticket.save
      flash[:notice] = 'Ticket has been created.'
      redirect_to @ticket.project
    else
      # render :action => "new"
    end
  end

  def edit
  end

  def update
    if @ticket.update_attributes(params[:ticket])
      flash[:notice] = 'Ticket has been updated.'
      redirect_back_or_default @ticket
    else
      render :action => "edit"
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
      @project = @ticket.project if @ticket
    end
end
