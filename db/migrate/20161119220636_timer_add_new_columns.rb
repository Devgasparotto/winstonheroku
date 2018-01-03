class TimerAddNewColumns < ActiveRecord::Migration[5.0]
  def change
	add_column :timers, :TicketId, :int
	add_column :timers, :RunAtDate, :timestamp
	add_column :timers, :HasRun, :boolean
	add_column :timers, :PreviousTimerId, :int
  end
end
