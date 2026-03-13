class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account_type, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :initial_balance, precision: 12, scale: 2, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end