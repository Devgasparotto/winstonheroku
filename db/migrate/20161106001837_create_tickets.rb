class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
    	t.integer :UserId
    	t.string :OffenceNumber
    	t.timestamp :NoticeOfOffenceDate
    	t.string :OfficerName
    	t.string :TicketFirstName
    	t.string :TicketLastName
    	t.integer :TicketAddressId
    	t.integer :OffenceLocationAddressId
    	t.integer :ChargeTypeId
    	t.integer :CourtHouseId
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime

    end
  end
end
