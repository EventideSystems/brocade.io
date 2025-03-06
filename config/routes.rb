# frozen_string_literal: true

Rails.application.routes.draw do
  # mount Rswag::Ui::Engine => '/api-docs'
  # mount Rswag::Api::Engine => '/api-docs'
  # use_doorkeeper do
  #   skip_controllers :authorizations, :applications,
  #                    :authorized_applications
  # end

  # devise_for :users, controllers: {
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations'
  # }

  devise_for :users, skip: %i[registrations sessions]

  namespace :api, defaults: { format: 'json' } do
    resources :items
  end

  resources :products

  get 'data_license', to: 'home#data_license'
  get 'documentation', to: 'home#documentation'
  get 'acknowledgements', to: 'home#acknowledgements'

  root to: 'home#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
