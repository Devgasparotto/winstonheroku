class AddTokenGenerationTimeToUserTable < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :token_generation_datetime, :datetime
  end
end
