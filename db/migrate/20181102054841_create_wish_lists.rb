class CreateWishLists < ActiveRecord::Migration[5.2]
  def change
    create_table :wish_lists do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :item, index: true
        t.timestamps
    end
  end
end
