class CreateDummyModelsTable < ActiveRecord::Migration
  def up
    create_table :dummy_models do |t|
      t.string :name
    end
  end

  def down
    drop_table :dummy_models
  end
end
