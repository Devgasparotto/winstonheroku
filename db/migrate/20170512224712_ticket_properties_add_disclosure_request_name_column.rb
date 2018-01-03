class TicketPropertiesAddDisclosureRequestNameColumn < ActiveRecord::Migration[5.0]
  def change
  	add_column :ticket_properties, :DisclosureRequestName, :string
  end
end
