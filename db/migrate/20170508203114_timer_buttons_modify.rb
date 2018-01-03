class TimerButtonsModify < ActiveRecord::Migration[5.0]
  def change
  	rename_column :timer_buttons, :TimerMessageId, :TimerTypeId
  end
end
