Rails.application.routes.draw do
  namespace :api do
    resources :tasks do
      collection do
        delete :recent_task
        post :bulk_tasks
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # Defines the root path route ("/")
  # root "posts#index"


  root "tasks#index"
  # tasksクラス
  resources :tasks
  # ↑これだけで以下全部生える：
  # GET /tasks → index
  # GET /tasks/new → new
  # GET /tasks/:id → show
  # GET /tasks/:id/edit → edit
  # POST /tasks → create
  # PATCH/PUT /tasks/:id → update
  # DELETE /tasks/:id → destroy
end
