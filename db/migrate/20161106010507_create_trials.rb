class CreateTrials < ActiveRecord::Migration[5.0]
  def change
    create_table :trials do |t|
    	t.string :TicketId
    	t.timestamp :TrialDate
    	t.timestamp :TrialDateReceivedDate
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime
    end
  end
end
