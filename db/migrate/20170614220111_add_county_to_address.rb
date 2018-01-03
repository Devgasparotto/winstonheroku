class AddCountyToAddress < ActiveRecord::Migration[5.0]
  def change
  	add_column :addresses, :CountyName, :string
  end
end
