class CreateDummyModels < ActiveRecord::Migration
  def change
    create_table :dummy_models do |t|
      t.string  :name, default: 'Anthony'
      t.string  :email
      t.boolean :saved, default: false

      t.timestamps
    end
  end
end
