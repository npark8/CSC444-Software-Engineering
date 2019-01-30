class AddApprovedToOnHoldItem < ActiveRecord::Migration[5.2]
  def change
    add_column :on_hold_items, :approved, :string, default: 'pending', null: false
  end
end
