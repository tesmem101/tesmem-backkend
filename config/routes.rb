Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'home#index'

  # devise_for :users, skip: [:registrations]

  devise_scope :user do
    get '/confirmation' => 'confirmations#show'
  end
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ApplicationApi, at: '/'
end
