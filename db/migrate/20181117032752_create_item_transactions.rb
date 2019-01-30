class CreateItemTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :item_transactions do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :item, index: true
    	t.datetime :returned_on
    	t.datetime :pick_up
    	t.datetime :due_date
    	t.string :user_status #lender/borrower
      t.timestamps
    end
  end
end
