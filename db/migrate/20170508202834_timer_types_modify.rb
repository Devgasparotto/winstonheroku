class TimerTypesModify < ActiveRecord::Migration[5.0]
  def change
  	add_column :timer_types, :Message, :string
  end
end
