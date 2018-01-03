
class AddChargeDescToTktProperty < ActiveRecord::Migration[5.0]
  def change
  	add_column :ticket_properties, :ChargeDesc, :string
  end
end
