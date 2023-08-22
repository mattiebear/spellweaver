# frozen_string_literal: true

Rails.application.routes.draw do
  get '/ping', to: 'health#index'

  resources :connections
  resources :game_sessions, except: :destroy
  resources :maps
end
