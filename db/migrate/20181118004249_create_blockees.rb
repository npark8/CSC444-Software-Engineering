class CreateBlockees < ActiveRecord::Migration[5.2]
  def change
    create_table :blockees do |t|
      t.integer :blockee_id
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :blockees, [:blockee_id,:user_id]
  end
end
