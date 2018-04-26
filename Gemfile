source 'https://rubygems.org'

# Specify your gem's dependencies in soulless.gemspec
gemspec

active_record_version = case ENV['ACTIVE_RECORD_VERSION'] || 'default'

when 'master'
  { git: 'https://github.com/rails/rails.git' }
when 'default'
  '~> 5.2'
else
  "~> #{ENV['ACTIVE_RECORD_VERSION']}"
end

group :test do
  gem 'coveralls', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'activerecord', '>= 4.2.0', '< 6.0'

  platforms :ruby do
    gem 'sqlite3'
  end
end
