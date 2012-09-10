Proveeduria::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match 'institutos/:id/display_logo' => 'institutos#display_logo'
  match 'articulos_listas/create' => 'articulos_listas#create', :as => 'create'
  #match 'compras/carrito_visitantes' => 'compras#carrito_visitantes'
  match 'compras/:instituto_id/instituto' => 'compras#instituto'
  match 'compras/:id/carrito_lista' => 'compras#carrito_lista'
  match 'compras/:id/compra_upd' => 'compras#compra_upd'
  match 'compras/carrito_visitante' => 'compras#carrito_visitante'
  match 'compras/carrito_compra' => 'compras#carrito_compra'
  match 'compras/carrito_checkout' => 'compras#carrito_checkout'
  match 'visitantes/registro' => 'visitantes#registro'
  match 'visitantes/registro_nuevo' => 'visitantes#registro_nuevo'
  match 'visitantes/registro_recurrente' => 'visitantes#registro_recurrente'

  match 'admin/login' => 'admin#login'
  match 'admin/logout' => 'admin#logout'
  match 'admin/entrada' => 'admin#entrada'

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
   match 'visitantes/:id/confirmacion_registro' => 'visitantes#confirmacion_registro', :as => 'confirmacion_registro'
   match 'institutos/:id/lista_articulos' => 'institutos#lista_articulos', :as => 'lista_articulos'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :articulos
  resources :visitantes
  resources :institutos
  resources :usuarios

  resources :listas do
      get :autocomplete_articulo_nombre_generico, :on => :collection
  end
  resources :articulos_listas
  resources :compras
  resources :admin


  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "compras#bienvenida"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
