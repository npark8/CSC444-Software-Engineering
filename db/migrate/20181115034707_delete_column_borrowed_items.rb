class DeleteColumnBorrowedItems < ActiveRecord::Migration[5.2]
  def change
  	remove_column :borrowed_items, :due_on
  end
end
