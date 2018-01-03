class AddTrialLanguageToTrials < ActiveRecord::Migration[5.0]
  def change
  	add_column :trials, :TrialLanguage, :string
  	add_column :trials, :LanguageToInterpretTo, :string
  end
end
