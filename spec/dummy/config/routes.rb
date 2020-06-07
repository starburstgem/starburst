# frozen_string_literal: true

Rails.application.routes.draw do
  mount Starburst::Engine, at: :starburst

  get :bootstrap, to: 'pages#bootstrap'
  get :custom, to: 'pages#custom'
  get :foundation, to: 'pages#foundation'
end
