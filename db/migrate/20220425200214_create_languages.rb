class CreateLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :languages do |t|
      t.string :value, index: true
      t.string :name, index: true
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
