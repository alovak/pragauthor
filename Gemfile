source 'http://rubygems.org'

gem 'rails', '3.1.0.rc4' 

gem 'haml-rails'
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'  
gem 'uglifier'  
  
gem 'jquery-rails'
gem 'rspec-rails'

gem 'sqlite3'

# Use unicorn as the web server
gem 'unicorn'

gem 'devise'

gem 'carrierwave'

gem 'simple_form', :git => 'https://github.com/plataformatec/simple_form.git'

gem 'spreadsheet'

gem 'mysql2'
# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
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
  gem 'faker'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'guard-spork'

  gem 'email_spec'
  gem 'ruby-debug19'
end

group :test do
  gem 'database_cleaner'
  gem 'simplecov', '>= 0.4.0', :require => false
end
