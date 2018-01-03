class TicketPropertiesAddGivenFamilyNames < ActiveRecord::Migration[5.0]
  def change
  	add_column :ticket_properties, :GivenName, :string
  	add_column :ticket_properties, :FamilyName, :string
  end
end
