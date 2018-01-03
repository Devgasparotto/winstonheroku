class TimersRemoveTimerMessageIdColumn < ActiveRecord::Migration[5.0]
  def change
  	remove_column :timers, :TimerMessageId
  end
end
