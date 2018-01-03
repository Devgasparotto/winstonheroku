class CreateTicketAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_attributes do |t|
      t.integer :TicketId
      t.string :AttributeName
      t.string :AttributeValue
      t.string :InsertUserName
	  t.timestamp :InsertDateTime
	  t.string :UpdateUserName
	  t.timestamp :UpdateDateTime
    end
  end
end
