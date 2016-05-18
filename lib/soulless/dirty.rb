module Soulless
  module Dirty
    def apply_changes
      changes_applied
    end

    def reload_changes!
      clear_changes_information
    end

    def rollback_changes!(attributes = changed)
      restore_attributes(attributes)
    end
  end
end
