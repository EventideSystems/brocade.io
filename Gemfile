# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Authorisation / authentication
gem 'devise'
gem 'doorkeeper'
gem 'rack-attack'
gem 'recaptcha'

# Pagination

gem 'api-pagination'
gem 'pagy'

gem 'mailjet'

gem 'net-http' # Silence spurious warnings, see https://github.com/ruby/net-protocol/issues/10
# gem 'rswag'

gem 'csv'

gem 'data_migrate'

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'dotenv'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'foreman'
  gem 'pry'
  gem 'pry-byebug'
  # TODO: See https://github.com/pry/pry-coolline/issues/36
  # gem 'pry-coolline', github: 'owst/pry-coolline', branch: 'support_new_pry_config_api'
  # gem 'pry-coolline'
  gem 'pry-stack_explorer'
  gem 'rspec-rails'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'timecop'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rails-controller-testing'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'tailwindcss-rails', '~> 3.3.1'
