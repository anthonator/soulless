source 'https://rubygems.org'

# Specify your gem's dependencies in ar_book_finder.gemspec
gemspec

rails_version = case ENV['RAILS_VERSION'] || 'default'
when 'master'
  { git: 'https://github.com/rails/rails.git' }
when 'default'
  '~> 4.0'
else
  "~> #{ENV['RAILS_VERSION']}"
end

gem 'rails', rails_version

platforms :ruby do
  gem 'sqlite3'
end

platforms :ruby_19, :jruby_19 do
  if rails_version < '5.0'
    gem 'mime-types', '~> 2.99.1'
  end
end

platforms :jruby do
  gem "activerecord-jdbcsqlite3-adapter"
end

group :development do
  gem 'coveralls', require: false
end
