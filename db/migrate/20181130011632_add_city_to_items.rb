class AddCityToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :city, :string
  end
end
