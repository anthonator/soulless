require 'coveralls'
Coveralls.wear!

require 'soulless'

# Require supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| puts f; require f }