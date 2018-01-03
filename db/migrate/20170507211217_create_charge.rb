class CreateCharge < ActiveRecord::Migration[5.0]
  def change
    create_table :charges do |t|
    	t.string :Name
		t.string :Description
		t.string :InsertUserName
		t.timestamp :InsertDateTime
		t.string :UpdateUserName
		t.timestamp :UpdateDateTime
    end
  end
end
