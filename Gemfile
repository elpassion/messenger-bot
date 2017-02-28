source 'https://rubygems.org'
ruby '2.3.3'

gem 'bundler'
gem 'rake'
gem 'hanami',       '~> 0.9'
gem 'hanami-model', '~> 0.7'

gem 'pg'
gem 'sidekiq', '~> 4.0.2'
gem 'facebook-messenger'
gem 'wit'
gem 'workable'
gem 'nokogiri'
gem 'i18n'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun'
  gem 'foreman'
end

group :test, :development do
  gem 'pry'
  gem 'dotenv', '~> 2.0'
  gem 'vcr'
  gem 'webmock'
  gem 'factory_girl'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'database_cleaner'
end

group :production do
  # gem 'puma'
end
