Rails.application.routes.draw do

  mount Starburst::Engine => "/starburst"
  root to: 'pages#home'
end
