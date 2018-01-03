class CreateCourthouses < ActiveRecord::Migration[5.0]
  def change
    create_table :courthouses do |t|
    	t.string :Court
    	t.integer :ICON
    	t.integer :CourtHouseAddressId
    	t.string :Suite
    	t.string :GeneralPhoneNumber
    	t.string :GeneralFaxNumber
    	t.string :Prosecutor
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime
    end
  end
end
