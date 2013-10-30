source 'https://rubygems.org'

# Specify your gem's dependencies in ar_book_finder.gemspec
gemspec

rails_version = case ENV['RAILS_VERSION'] || 'default'
when 'master'
  { git: 'rails/rails' }
when 'default'
  '~> 4.0'
else
  "~> #{ENV['RAILS_VERSION']}"
end

gem 'activesupport', rails_version
gem 'activemodel', rails_version

group :development do
  gem 'bundler'
  gem 'coveralls', require: false
  gem 'rake'
end

group :test do
  gem 'rspec'
  gem 'simplecov'
end