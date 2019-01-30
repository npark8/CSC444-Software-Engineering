class AddLongitudeToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :longitude, :float
  end
end
