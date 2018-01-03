class TimerMessageAddTimerTypeId < ActiveRecord::Migration[5.0]
  def change
  	add_column :timer_messages, :TimerTypeId, :int
  end
end
