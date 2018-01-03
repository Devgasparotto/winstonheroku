class AddIsCurrentToTicketStatuses < ActiveRecord::Migration[5.0]
  def change
    add_column 			:ticket_statuses, :IsCurrent, :boolean
    add_column 			:ticket_statuses, :Status, :string
    remove_column 	:ticket_statuses, :TicketStatusId 
  end
end
