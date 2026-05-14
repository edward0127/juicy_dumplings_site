Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  get "/menu", to: "pages#menu"
  get "/order", to: "orders#new"
  post "/order", to: "orders#create"
  get "/order/:public_id/confirmation", to: "orders#show", as: :order_confirmation
  get "/order/:public_id/success", to: "orders#success", as: :order_success

  post "/cart_items/:menu_item_id", to: "cart_items#create", as: :cart_item_add
  patch "/cart_items/:menu_item_id", to: "cart_items#update", as: :cart_item_update
  delete "/cart_items/:menu_item_id", to: "cart_items#destroy", as: :cart_item_remove
  delete "/cart", to: "cart_items#clear", as: :cart_clear

  get "/book", to: "bookings#new"
  post "/book", to: "bookings#create"
  get "/booking_slots", to: "bookings#slots"
  get "/book/:id/confirmation", to: "bookings#show", as: :booking_confirmation

  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
  post "/contact", to: "contact_messages#create"
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"

  get "/sitemap.xml", to: "seo#sitemap", as: :sitemap, defaults: { format: :xml }
  get "/robots.txt", to: "seo#robots", as: :robots, defaults: { format: :text }

  namespace :admin do
    root "dashboard#index"
    get "login", to: "sessions#new", as: :login
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout

    resources :categories, except: :show
    resources :menu_items, except: :show
    resources :opening_hours, except: :show

    resources :orders, only: %i[index show update] do
      collection do
        get :export
      end
    end

    resources :bookings, only: %i[index show update] do
      collection do
        get :export
      end
    end

    resource :settings, only: %i[edit update]
  end
end
