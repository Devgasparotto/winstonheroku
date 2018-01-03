class RemoveTestNamesTable < ActiveRecord::Migration[5.0]
  def change
  	drop_table :test_names
  end
end
