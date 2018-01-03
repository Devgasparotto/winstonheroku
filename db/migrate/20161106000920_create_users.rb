class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
    	t.string :FirstName
    	t.string :LastName
    	t.string :SenderId
    	t.string :FacebookId
    	t.string :ProfilePicURL
    	t.integer :MailingAddressId
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime


    end
  end
end
