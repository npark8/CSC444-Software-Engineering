class AddInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phonenum, :string
    add_column :users, :address, :string
  end
end
