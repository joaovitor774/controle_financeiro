class CreateEntryTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :entry_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
