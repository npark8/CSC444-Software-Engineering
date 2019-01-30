class AddReviewIdToItemTransactions < ActiveRecord::Migration[5.2]
  def change
  	 add_reference :item_transactions, :review_borrower, index: true
  	 add_reference :item_transactions, :review_lender_and_item, index: true
  end
end
