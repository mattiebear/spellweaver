# frozen_string_literal: true

Rails.application.routes.draw do
  get '/ping', to: 'health#index'

  resources :connections
  resources :maps
end
