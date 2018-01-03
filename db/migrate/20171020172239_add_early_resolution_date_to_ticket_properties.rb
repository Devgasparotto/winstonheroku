class AddEarlyResolutionDateToTicketProperties < ActiveRecord::Migration[5.0]
  def change
  	if !ActiveRecord::Base.connection.column_exists?(:ticket_properties, :EarlyResolutionDateTime)
  		add_column :ticket_properties, :EarlyResolutionDateTime, :timestamp
  	end
  end
end
