class CreateCategoryKinds < ActiveRecord::Migration[8.1]
  def change
    create_table :category_kinds do |t|
      t.string :name

      t.timestamps
    end
  end
end
