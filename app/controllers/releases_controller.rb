class ReleasesController < ApplicationController
  before_filter :set_release
  before_filter :set_project
  
  def show
  end

  def new
  end

  def create
    if @release.save
      @release.push!
      flash[:notice] = 'Release has been created.'
      redirect_to @release
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @release.update_attributes(params[:release])
      @release.push!
      flash[:notice] = 'Release has been updated.'
      redirect_to @release
    else
      render :action => "edit"
    end
  end

  def destroy
    @release.destroy
    redirect_to project_path(@release.project)
  end
  
  protected
  
    def set_release
      @release = params[:id] ? Release.find(params[:id]) : Release.new(params[:release])
    end
    
    def set_project
      if params[:project_id]
        @project = @release.project = Project.find(params[:project_id]) 
      elsif @release
        @project = @release.project 
      end
    end
    
    def filter
      return '' unless filter = params[:filter]
      sql = []
      sql << filter_state
      sql << filter_association(:release)
      sql << filter_association(:sprint)
      sql.compact * ' AND '
    end
    
    def filter_state
      return nil unless states = params[:filter][:state]
      'state IN (' + states.map{|state| "'#{state}'"} * ', ' + ')'
    end
    
    def filter_association(type)
      return nil unless ids = params[:filter][type]
      "#{type}_id IN (" + ids * ', ' + ')' if ids
    end
end
