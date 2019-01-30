class CreateOnHoldItems < ActiveRecord::Migration[5.2]
  def change
    create_table :on_hold_items do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :item, index: true
    	t.date :req_on
        t.timestamps
    end
  end
end
