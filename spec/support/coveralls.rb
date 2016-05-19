require 'coveralls'
require 'simplecov'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec'
end

Coveralls.wear! if Object.const_defined?('Coveralls')
