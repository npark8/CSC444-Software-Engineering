class AddLatitudeToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :latitude, :float
  end
end
