Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, skip: [:registrations]
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ApplicationApi, at: '/'
end
