class AddColsToBorrowedItems < ActiveRecord::Migration[5.2]
  def change
  	add_column :borrowed_items, :temp_due_date, :datetime
  	add_column :borrowed_items, :approved, :string, default: 'pending'
  end
end
