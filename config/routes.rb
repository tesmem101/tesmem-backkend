Rails.application.routes.draw do
  # devise_for :users
  mount ApplicationApi, at: '/'
end
