class CreateTestNames < ActiveRecord::Migration[5.0]
  def change
    create_table :test_names do |t|
    	t.integer :TestNameId
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime
    end
  end
end
