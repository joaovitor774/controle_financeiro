class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category_kind, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
      t.index [:user_id, :name], unique: true
    end
  end
end
