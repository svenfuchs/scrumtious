module Railslove
	module ActionController
		module Redirect
		
			def self.included(base)
        base.before_filter :save_return_to
      end
			
			protected
			
			def redirect_back_or_default(default_url,respond=false)
			  redirect_url = params[:return_to] || session[:return_to] || default_url
			  session[:return_to] = nil

			  # if respond is false... just redirect... no matter which farmat the user wants.
			  redirect_to(redirect_url) and return unless respond

			  respond_to do |format|
			   format.html { redirect_to redirect_url }
			   format.xml  { head :moved, :location => redirect_url }
			   format.js {
			     render :update do |page|
			       page.redirect_to redirect_url
			     end
			   }
			  end
			end
			alias redirect_back redirect_back_or_default
			alias redirect_bod redirect_back_or_default
			
			# thanks http://ethilien.net/archives/better-redirects-in-rails/
			def redirect_away(*params)
			  session[:return_to] = request.request_uri
			  redirect_to(*params)
			end
			
			# thanks http://ethilien.net/archives/better-redirects-in-rails/
			def save_return_to
			  session[:return_to] = params[:return_to] if params[:return_to]
			end
			
		end
		
		module RedirectHelper
		
		  # thanks http://ethilien.net/archives/better-redirects-in-rails/
			def link_away(name, options = {}, html_options = nil)
			  link_to(name, { :return_to => url_for(:only_path => true) }.update(options.symbolize_keys), html_options)
			end
			
		end
	end
end