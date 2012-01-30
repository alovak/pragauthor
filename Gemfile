source 'http://rubygems.org'

gem 'rack'
gem 'rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'rspec-rails'
gem 'devise'
gem 'carrierwave'
gem 'simple_form'
gem 'spreadsheet'
gem 'mysql2'
gem 'exception_notification'
gem 'chronic'
gem 'money', :path => 'vendor/gems/money-3.7.1'

group :assets do
  gem 'compass', "~> 0.12.alpha"
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :production do
  gem 'therubyracer'
end

group :development do
  gem 'capistrano'
  gem 'unicorn'
end

group :development, :test do
  gem 'growl'
  gem 'rb-fsevent'
  gem 'timecop'

  gem 'spork', '~>0.9.0rc'
  gem 'capybara', '~>1.0.0'
  gem 'cucumber-rails'
  gem 'cucumber-websteps'
  gem 'rspec2-rails-views-matchers'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'guard-spork'

  gem 'email_spec'
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  gem 'database_cleaner'
  gem 'simplecov', '>= 0.4.0', :require => false
end
