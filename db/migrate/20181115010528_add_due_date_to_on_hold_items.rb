class AddDueDateToOnHoldItems < ActiveRecord::Migration[5.2]
  def change
  	add_column :on_hold_items, :due_date, :datetime
  end
end
