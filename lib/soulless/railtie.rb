module Soulless
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      app.config.paths.add('app/forms', eager_load: true)
    end
  end
end