class TrialsReorderColumns < ActiveRecord::Migration[5.0]
  def change
  	remove_column :trials, :TrialDate
  end
end
