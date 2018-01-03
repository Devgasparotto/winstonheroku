class TrialsModifyColumns < ActiveRecord::Migration[5.0]
  def change
  	add_column :trials, :TrialDateTime, :timestamp
  	add_column :trials, :CourthouseId, :int
  	add_column :trials, :Courtroom, :string
  	add_column :trials, :IsComplete, :boolean
  	remove_column :trials, :TrialDateReceivedDate
  end
end
