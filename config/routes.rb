Rails.application.routes.draw do
  root :controller => 'welcome', :action => :index
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
