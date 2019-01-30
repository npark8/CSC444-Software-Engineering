class AddAddressToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :address, :text
  end
end
