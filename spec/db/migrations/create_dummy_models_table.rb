class CreateDummyModelsTable < ActiveRecord::Migration[5.0]
  def up
    create_table :dummy_models do |t|
      t.string :name
      t.text   :soulless
    end
  end

  def down
    drop_table :dummy_models
  end
end
