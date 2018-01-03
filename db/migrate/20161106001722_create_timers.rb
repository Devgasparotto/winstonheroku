class CreateTimers < ActiveRecord::Migration[5.0]
  def change
    create_table :timers do |t|
    	t.integer :TimerTypeId
    	t.integer :TimerMessageId
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime
    end
  end
end
