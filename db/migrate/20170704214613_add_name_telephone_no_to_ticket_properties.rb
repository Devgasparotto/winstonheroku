class AddNameTelephoneNoToTicketProperties < ActiveRecord::Migration[5.0]
  def change
  	add_column :ticket_properties, :DefendantName, :string
  	add_column :ticket_properties, :TelephoneNo, :string
  end
end
