class CreateReviewLenderAndItems < ActiveRecord::Migration[5.2]
  def change
    create_table :review_lender_and_items do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :item, index: true
    	t.integer :rating, null: false
    	t.text :comment
      t.timestamps
    end
  end
end
