# frozen_string_literal: true

Rails.application.routes.draw do
  mount Starburst::Engine, at: :starburst
  root to: 'pages#home'
end
