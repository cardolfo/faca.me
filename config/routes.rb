Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "shorter#index"
  post '/shorter', to: 'shorter#shorter'
  get '/:id', to: 'shorter#redirect'
end
