class AddParsedAddressColumnsToAddresses < ActiveRecord::Migration[5.0]
  def change
  	add_column :addresses, :StreetNo, :string
  	add_column :addresses, :Street, :string
  	add_column :addresses, :Apt, :string
  end
end
