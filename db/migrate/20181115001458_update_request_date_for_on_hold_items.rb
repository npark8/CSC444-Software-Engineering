class UpdateRequestDateForOnHoldItems < ActiveRecord::Migration[5.2]
  def change
  	change_column :on_hold_items, :req_on, :datetime
  end
end