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
gem 'jquery-turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'warden'
gem 'rails_admin', '~> 2.0'
gem 'activeadmin'
gem 'cancancan'
gem 'fog-aws'
gem 'figaro'
gem 'unsplash'
gem 'nokogiri'
gem 'listen'
gem 'will_paginate', '~> 3.1.0'
gem 'google-cloud-translate'
gem 'pexels'

gem 'bootstrap-sass', '~> 3.4.1'
gem 'sassc-rails', '>= 2.1.0'
gem 'jquery-rails'

gem "active_material", github: "vigetlabs/active_material"
gem "active_admin-sortable_tree", "~> 2.0.0"
gem 'activeadmin-searchable_select'

gem "rest-client"
gem 'carrierwave-base64'


gem 'rack-mini-profiler'#, require: false
# # For memory profiling
# gem 'memory_profiler'
# # For call-stack profiling flamegraphs
# gem 'stackprof'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.6'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'solargraph'
  gem "letter_opener"
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
