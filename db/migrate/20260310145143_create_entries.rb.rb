class CreateEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :entry_type, null: false, foreign_key: true
      t.references :entry_status, null: false, foreign_key: true
      t.string :description, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.date :occurred_on, null: false
      t.text :notes
      t.timestamps

      t.index :occurred_on
    end
  end
end