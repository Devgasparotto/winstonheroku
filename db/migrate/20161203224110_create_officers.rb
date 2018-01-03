class CreateOfficers < ActiveRecord::Migration[5.0]
  def change
    create_table :officers do |t|
      t.integer :TicketId
      t.string :Name
      t.integer :Number
      t.string :Division
      t.string :InsertUserName
	  t.timestamp :InsertDateTime
	  t.string :UpdateUserName
	  t.timestamp :UpdateDateTime
    end
  end
end
