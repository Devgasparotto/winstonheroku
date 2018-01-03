class ModifyChargesTableForDisclosureChanges < ActiveRecord::Migration[5.0]
  def change
  	remove_column :charges, :Name, :string
  	remove_column :charges, :Description, :string
  	remove_column :charges, :InsertUserName, :string
  	remove_column :charges, :UpdateUserName, :string
  	remove_column :charges, :UpdateDateTime, :timestamp
  	add_column :charges, :ChargeId, :string
  	add_column :charges, :ChargeIdName, :string
  end
end
