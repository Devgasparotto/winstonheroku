class CreatePromoCodes < ActiveRecord::Migration[5.0]
	def change
		create_table :promo_codes do |t|
			t.string :Code
			t.integer :NumberOfUses
			t.integer :MaxNumberOfUses
			t.timestamp :ExpiryDate
			t.string :InsertUserName
			t.timestamp :InsertDateTime
			t.string :UpdateUserName
			t.timestamp :UpdateDateTime
		end
	end
end
