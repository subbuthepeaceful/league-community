ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'logins', :action => 'destroy'
  map.login '/login', :controller => 'logins', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.authenticate '/authenticate', :controller => 'logins', :action => 'authenticate'
  map.forgot_password '/forgot_password', :controller => 'logins', :action => 'forgot_password'
  map.resources :users, :member => { :activate => :get, :perform_activation => :post, :change_password => :get, :update_password => :post }

  map.resource :login
  #map.dashboard '/dashboard', :controller => 'dashboard', :action => 'index'

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

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  map.namespace :admin do |admin|
    admin.root :controller => "dashboard"
    admin.resources :programs, :collection => { :schedules => :get } do |program|
      program.resources :sessions, :collection => { :schedules => :get }, :member => { :schedule => :get, :add_event => :post} do |session|
        session.resources :divisions, :member => { :define_dates => :get, :update_schedule => :post, :add_event => :post } do |division|
          division.resources :teams
        end
      end
    end
    admin.resources :participants, :member => { :resend_activation => :get, :activate => :get}
    admin.resources :teams, :member => { :update => :post }
    admin.resources :divisions, :member => { :schedule => :get, :activate => :post} do |division|
      division.resources :games, :member => { :update => :post }
    end
    admin.resources :locations
    admin.resources :sponsors
  end
  
  map.resources :hubs, :member => { :view => :get, :votes => :get } do |hub|
    hub.resources :admin_roles
  end
  map.resources :programs
  map.resources :divisions, :member => { :schedule => :get, :gamelist => :get, :view => :get, :votes => :get, :scores => :get, :standings => :get } do |division|
    division.resources :admin_roles
  end
  map.resources :participants, :member => { :clear_snack_signup=>:get,
                                            :snack_signup=>:get,
                                            :gamelist=>:get, 
                                            :schedule => :get, 
                                            :dashboard => :get,
                                            :roster=>:get, 
                                            :resources=>:get,
                                            :sponsors=>:get,
                                            :availability=>:get,
                                            :update_availability => :post, 
                                            :update_teamname => :post,
                                            :update_profile_photo => :post,
                                            :update_contact_profile_photo => :post,
                                            :update_team_logo => :post
                                            } do |participant|
    participant.resources :messages, :member => { :reply => :post, :read => :post }
    participant.resources :pictures, :collection => {:preview => :post, :share => :post }
    participant.resources :events
    participant.resources :teams
  end
  
  map.resources :teams, :member => { :schedule => :get,
                                     :gamelist => :get,
                                     :update_jersey_number => :post,
                                     :update_player_names_and_jerseys => :post
                                   } do |team|
    team.resources :games do |game|
      game.resources :game_reports, :member => { :view => :get, :confirm => :post, :plain => :get, :public => :get}
    end
  end
  map.resources :contacts
  #map.resources :messages

  map.sponsorship_thank_you '/sponsorship_payment_thank_you', :controller => 'sponsors', :action => 'thank_you'
  map.resources :sponsors, :member => { :review => :get }

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"
  #map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
  map.connect '/assign_coaches', :controller => "admin/teams", :action => "assign_coaches"
  map.connect '/import_participants', :controller => "admin/participants", :action => "import"
  map.connect '/admin/partcipants/confirm_import', :controller => "admin/participants", :action => "confirm_import"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
