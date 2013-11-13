module Soulless
  module Dirty
    private
    def init_dirty
      @changed_attributes = {}
    end
      
    def changes_applied
      @previously_changed = changed
      @changed_attributes = {}
    end
  end
end