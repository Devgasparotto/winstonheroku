class AddTicketsIsCurrent < ActiveRecord::Migration[5.0]
  def change
  	add_column :tickets, :IsCurrent, :boolean
  end
end
