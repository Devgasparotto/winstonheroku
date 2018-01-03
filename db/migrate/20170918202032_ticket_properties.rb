class TicketProperties < ActiveRecord::Migration[5.0]
  def change
  	add_column :ticket_properties, :OfficerId, :integer
  end
end
