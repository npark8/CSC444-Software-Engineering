class CreateReportUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :report_users do |t|
    	t.integer :reporter_id    	
    	t.integer :reportee_id
    	t.text :reason
    	t.text :comment
    end
  end
end
