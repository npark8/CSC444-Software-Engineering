class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
    	t.string :name, null: false
    	t.text :descr
    	t.string :status, null: false
    	t.belongs_to :user, index: true
    	t.timestamps
    end
  end
end
