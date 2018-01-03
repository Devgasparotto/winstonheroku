class AddFaxNumberToTicketProperty < ActiveRecord::Migration[5.0]
  def change
  	add_column :ticket_properties, :FaxNo, :string
  end
end
