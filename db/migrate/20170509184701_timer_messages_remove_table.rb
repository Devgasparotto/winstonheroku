class TimerMessagesRemoveTable < ActiveRecord::Migration[5.0]
  def change
  	drop_table :timer_messages
  end
end
