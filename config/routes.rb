AuthlogicSample::Application.routes.draw do
  resources :entries

  resources :user_sessions

  match 'login' => 'user_sessions#new', as: :login
  match 'logout' => 'user_sessions#destroy', as: :logout

  resources :users
  resource :user, as: 'account'

  match 'signup' => 'users#new', as: :signup

  root to: 'user_sessions#new'
end
