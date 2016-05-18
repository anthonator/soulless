$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'soulless'
require 'active_record'
require 'db/migrations/create_dummy_models_table'

# Require supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    CreateDummyModelsTable.migrate(:up)
  end

  config.before(:each) do
    DummyModel.destroy_all
  end

  config.after(:suite) do
    CreateDummyModelsTable.migrate(:down)
  end
end
