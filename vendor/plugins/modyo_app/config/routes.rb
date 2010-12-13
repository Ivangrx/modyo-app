ActionController::Routing::Routes.draw do |map|

  map.session_create '/create'  , :controller => 'session', :action => 'callback'
  map.callback       '/callback', :controller => 'session', :action => 'callback'

end