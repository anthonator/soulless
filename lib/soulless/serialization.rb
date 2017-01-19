module Soulless
  module Serialization
    def load(value)
      if value.is_a?(Array)
        value.map do |data|
          self.new(data)
        end
      elsif value.is_a?(Hash)
        self.new(value)
      elsif value.is_a?(String)
        self.new(JSON.parse(value))
      else
        value
      end
    end

    def dump(value)
      value.to_json
    end
  end
end
