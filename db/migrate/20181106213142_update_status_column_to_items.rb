class UpdateStatusColumnToItems < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :status, :string, default: "available"
  end
end
