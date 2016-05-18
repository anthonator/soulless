module Soulless
  module Callbacks
    def self.prepended(base)
      base.define_model_callbacks :validation
    end

    def valid?(context = nil)
      run_callbacks :validation do
        super(context)
      end
    end
  end
end
