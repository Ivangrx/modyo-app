ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => "site"

  map.session_create '/create'  , :controller => 'session', :action => 'create'
  map.callback       '/callback', :controller => 'session', :action => 'callback'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
