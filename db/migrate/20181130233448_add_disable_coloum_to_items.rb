class AddDisableColoumToItems < ActiveRecord::Migration[5.2]
  def change
  	add_column :items, :disable, :boolean, default: false
  	add_column :users, :disable, :boolean, default: false
  end
end
