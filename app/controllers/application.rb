# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout 'default'
  helper :all # include all helpers, all the time
  before_filter :set_current_user

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'ff391b6b5153e3038f019d85c1ceabe3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def set_current_user
    @current_user = User.find_by_id session[:current_user_id] if session[:current_user_id]
  end
  
  helper_method :current_user
  def current_user
    @current_user
  end
end
