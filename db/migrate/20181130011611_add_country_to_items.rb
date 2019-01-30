class AddCountryToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :country, :string
  end
end
