class CreateTicketSteps < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_steps do |t|
    	t.integer :StepNumber
    	t.string :Step
    	t.string :StepDescription
    	t.string :InsertUserName
    	t.timestamp :InsertDateTime
    	t.string :UpdateUserName
    	t.timestamp :UpdateDateTime
      
    end
  end
end
