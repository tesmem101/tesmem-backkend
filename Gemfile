source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.2'

gem 'carrierwave', '~> 1.0'
gem 'coffee-rails', '~> 4.2'
gem 'decent_exposure', '3.0.0'
gem 'devise'
gem 'factory_bot_rails'
gem 'faker'
gem 'grape'
gem 'grape-active_model_serializers'
gem 'grape_on_rails_routes'
gem 'grape-swagger'
gem 'hashie-forbidden_attributes'
gem 'jbuilder', '~> 2.5'
gem 'kaminari'
gem 'mini_magick'
gem 'omniauth'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'rack-cors', require: 'rack/cors'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'warden'
gem 'rails_admin', '~> 2.0'
gem 'cancancan'
gem 'fog-aws'
gem 'figaro'
gem 'unsplash'
gem 'nokogiri'
gem 'listen'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.6'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
