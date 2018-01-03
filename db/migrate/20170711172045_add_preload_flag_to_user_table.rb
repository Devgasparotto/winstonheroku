class AddPreloadFlagToUserTable < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :has_been_preloaded_flag, :boolean
  end
end
