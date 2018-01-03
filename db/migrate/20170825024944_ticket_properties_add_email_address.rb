class TicketPropertiesAddEmailAddress < ActiveRecord::Migration[5.0]
  def change
  	add_column :ticket_properties, :EmailAddress, :string
  end
end
