class CreateTicketStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_statuses do |t|
    	t.integer :TicketId
    	t.integer :TicketStatusId
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime

    end
  end
end
