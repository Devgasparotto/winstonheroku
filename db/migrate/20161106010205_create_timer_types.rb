class CreateTimerTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :timer_types do |t|
    	t.string :TypeName
    	t.string :TypeDescription
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime
    end
  end
end
