class AddColumnToItemTransactions < ActiveRecord::Migration[5.2]
  def change
  	add_column :item_transactions, :other_user_id, :integer
  end
end
