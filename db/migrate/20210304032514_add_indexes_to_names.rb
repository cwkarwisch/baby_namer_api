class AddIndexesToNames < ActiveRecord::Migration[6.1]
  def change
    add_index :names, [:name, :sex, :popularity, :year]
  end
end
