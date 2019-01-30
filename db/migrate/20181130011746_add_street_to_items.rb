class AddStreetToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :street, :string
  end
end
