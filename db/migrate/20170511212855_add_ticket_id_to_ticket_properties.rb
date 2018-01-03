class AddTicketIdToTicketProperties < ActiveRecord::Migration[5.0]
  def change
  	add_column :ticket_properties, :TicketId, :integer
  end
end
