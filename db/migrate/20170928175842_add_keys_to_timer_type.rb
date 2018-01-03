class AddKeysToTimerType < ActiveRecord::Migration[5.0]
  def change
  	add_index :timer_types, :TypeName, unique: true
  end
end
