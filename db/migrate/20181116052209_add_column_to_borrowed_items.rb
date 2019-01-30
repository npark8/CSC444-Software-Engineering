class AddColumnToBorrowedItems < ActiveRecord::Migration[5.2]
  def change
  	add_column :borrowed_items, :returned_on, :datetime
  end
end
