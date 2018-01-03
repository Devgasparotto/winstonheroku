class CreateTimerMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :timer_messages do |t|
    	t.string :Message
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime
    end
  end
end
