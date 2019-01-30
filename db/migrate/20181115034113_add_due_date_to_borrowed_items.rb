class AddDueDateToBorrowedItems < ActiveRecord::Migration[5.2]
  def change
  	add_column :borrowed_items, :due_date, :datetime
  end
end
