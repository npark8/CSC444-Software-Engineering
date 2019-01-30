class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
    	t.belongs_to :user, index: true
    	t.boolean :i_due_alert, default: true
    	t.boolean :i_req_by_others, default: true
    	t.boolean :i_req_approval_alert, default: true
      t.timestamps
    end
  end
end
