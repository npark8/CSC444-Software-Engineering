class CreateBorrowedItems < ActiveRecord::Migration[5.2]
  def change
    create_table :borrowed_items do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :item, index: true
    	t.date :due_on
    	t.timestamps
    end
  end
end
