class AddBlockNameToTimerButtons < ActiveRecord::Migration[5.0]
  def change
  	add_column :timer_buttons, :BlockName, :string
  end
end
