module Soulless
  module Serialization
    def load(value)
      if value.is_a?(Array)
        value.map do |data|
          self.new(data)
        end
      elsif value.is_a?(Hash)
        self.new(value)
      else
        value
      end
    end

    def dump(value)
      value
    end
  end
end
