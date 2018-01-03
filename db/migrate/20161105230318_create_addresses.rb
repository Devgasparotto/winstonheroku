class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
    	t.string :AddressText
    	t.string :GoogleMapAddressURL
    	t.string :StreetName
    	t.string :StreetNumber
    	t.string :PostalCode
    	t.string :City
    	t.string :Municipality
    	t.string :Province 
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime
    end
  end
end
