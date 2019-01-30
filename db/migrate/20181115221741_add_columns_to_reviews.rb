class AddColumnsToReviews < ActiveRecord::Migration[5.2]
  def change
  	add_column :review_lender_and_items, :lender_id, :integer
  	add_column :review_borrowers, :borrower_id, :integer
  end
end
