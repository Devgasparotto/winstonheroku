class FixTimerButtons < ActiveRecord::Migration[5.0]
  def change
  	if !ActiveRecord::Base.connection.column_exists?(:timer_buttons, :BlockName)
  		add_column :timer_buttons, :BlockName, :string
  	end
  end
end
