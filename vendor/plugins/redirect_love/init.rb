require "redirect_love"
ActionController::Base.send(:include, Railslove::ActionController::Redirect)
ApplicationHelper.send(:include, Railslove::ActionController::RedirectHelper)