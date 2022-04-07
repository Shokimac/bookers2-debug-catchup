class AddColumnToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :chat_id, :integer
    add_column :rooms, :user_room_id, :integer
  end
end
