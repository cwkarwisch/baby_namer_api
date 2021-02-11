class CreateNames < ActiveRecord::Migration[6.1]
  def change
    create_table :names do |t|
      t.string :name, null: false
      t.string :sex, null: false
      t.integer :count, null: false
      t.integer :popularity, null: false
      t.integer :year, null: false
      t.string  :country, null: false

      t.timestamps
    end
  end
end
