class CreateRecalls < ActiveRecord::Migration[5.0]
  def change
    create_table :recalls do |t|
    	t.integer :UserId
    	t.string :RecallBlock
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime
    end
  end
end
