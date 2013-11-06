#require 'coveralls'
#Coveralls.wear!

require File.expand_path("../../spec/dummy/config/environment", __FILE__)

require 'soulless'

# Require supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  DatabaseCleaner.strategy = :transaction
  
  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end
  
  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end