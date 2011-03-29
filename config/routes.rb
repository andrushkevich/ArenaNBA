ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  map.sitemap "/sitemap.xml", :controller => "sitemap", :action => "xml"
    
  map.connect ":lang/", :controller => "front", :action=>'index', :lang => /(ru|en)/
  map.connect ":lang/:month/:day/:year/", :controller => "front",:action=>'index',
    :month=>/\d{1,2}/, :day=>/\d{1,2}/, :year=>/\d{4}/, :lang => /(ru|en)/
  map.connect ":lang/:article_type/:id", :controller => "front", :action=>'show_article',
    :article_type => /\w+/ ,:id => /\d+/, :lang => /(ru|en)/
  map.connect ":lang/static/:url", :controller => "front", :action=>'static_content',
    :url=>/[^\/;,?]+/, :lang => /(ru|en)/
  
  map.connect ":lang/:type/teams.html", :controller => "front", :action => "teams_list",
    :lang => /(ru|en)/
  
  map.connect ":lang/:id/player.html", :controller => "front", :action => "player",
    :lang => /(ru|en)/
  
  map.connect ":lang/:id/team.html", :controller => "front", :action => "team",
    :lang => /(ru|en)/
  
  map.connect ":lang/:type/rate.html", :controller => "front", :action => "rate",
    :lang => /(ru|en)/
    
  

  map.connect "admin/user/:action", :controller=>"admin/user"
  map.connect "admin/user_type/:action", :controller=>"admin/user_type"
  map.connect "admin/team/:action", :controller=>"admin/team"
  map.connect "admin/team_item/:action", :controller=>"admin/team_item"
  map.connect "admin/team_division/:action", :controller=>"admin/team_division"
  map.connect "admin/team_type/:action", :controller=>"admin/team_type"
  map.connect "admin/setting/:action", :controller=>"admin/setting"
  map.connect "admin/language/:action", :controller=>"admin/language"
  map.connect "admin/content/:action", :controller=>"admin/content"
  map.connect "admin/season/:action", :controller=>"admin/season"
  map.connect "admin/winner_type/:action", :controller=>"admin/winner_type"
  map.connect "admin/game/:action", :controller=>"admin/game"
  map.connect "admin/player/:action", :controller=>"admin/player"
  map.connect "admin/player_position/:action", :controller=>"admin/player_position"
  map.connect "admin/player_game/:action", :controller=>"admin/player_game"
  map.connect "admin/player_team/:action", :controller=>"admin/player_team"
  map.connect "admin/article/:action", :controller=>"admin/article"
  map.connect "admin/article_item/:action", :controller=>"admin/article_item"
  map.connect "admin/article_type/:action", :controller=>"admin/article_type"
  map.connect "admin/matchup_article/:action", :controller=>"admin/matchup_article"
  map.connect "admin/review_article/:action", :controller=>"admin/review_article"
  map.connect "admin/comment/:action", :controller=>"admin/comment"
     
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "front"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
