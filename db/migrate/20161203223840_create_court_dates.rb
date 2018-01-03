class CreateCourtDates < ActiveRecord::Migration[5.0]
  def change
    create_table :court_dates do |t|
		t.integer :TicketId
		t.timestamp :Date
		t.string :Time
		t.string :InsertUserName
		t.timestamp :InsertDateTime
		t.string :UpdateUserName
		t.timestamp :UpdateDateTime
    end
  end
end
