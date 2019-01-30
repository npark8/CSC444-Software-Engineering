class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null:false
      t.string :password_digest, null:false
      t.string :fname, null:false
      t.string :lname, null:false
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
