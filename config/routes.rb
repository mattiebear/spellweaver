# frozen_string_literal: true

Rails.application.routes.draw do
  get '/ping', to: 'health#index'

  namespace :game do
    resources :maps
    resources :sessions
  end

  namespace :network do
    resources :connections
  end
end
