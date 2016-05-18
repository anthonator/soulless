require 'support/models/soulless_model'

class SoullessInheritanceModel < Soulless::Model
  inherit_from SoullessModel, { use_database_default: [:name],
                                exclude: :email,
                                include_timestamps: true }
end
