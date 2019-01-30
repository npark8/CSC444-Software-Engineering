class ChangeDefaultBorrowedItems < ActiveRecord::Migration[5.2]
  def change
  	change_column :borrowed_items, :approved, :string, default: nil
  end
end
