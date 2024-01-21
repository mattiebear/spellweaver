# frozen_string_literal: true

Rails.application.routes.draw do
  get '/ping', to: 'health#index'

  resources :connections, controller: 'network/connections'
  resources :maps, controller: 'game/maps'
  resources :sessions, controller: 'game/sessions'
end
