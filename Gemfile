# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Primary framework
gem 'rails', '~> 7.0.7'

# Server
gem 'puma', '~> 5.0'
gem 'rack-cors'

# Database and record management
gem 'pg', '~> 1.1'

# Serialization
gem 'blueprinter'
gem 'olive_branch'

# IAM
gem 'clerk-sdk-ruby', require: 'clerk'
gem 'jwt'
gem 'pundit'

# Platform augments
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  # Environment config
  gem 'dotenv-rails'

  # Debugging
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  # Linting
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  # Testing
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'

  # Optimization
  gem 'bullet'
end

group :test do
  # Coverage
  gem 'simplecov', require: false
end
