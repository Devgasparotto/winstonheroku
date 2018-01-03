class CreateTimerButtons < ActiveRecord::Migration[5.0]
  def change
    create_table :timer_buttons do |t|
		t.integer :TimerMessageId
		t.string :ButtonText
		t.string :InsertUserName
		t.timestamp :InsertDateTime
		t.string :UpdateUserName
		t.timestamp :UpdateDateTime
    end
  end
end
