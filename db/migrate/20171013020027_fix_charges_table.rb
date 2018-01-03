class FixChargesTable < ActiveRecord::Migration[5.0]
  def change
  	if !ActiveRecord::Base.connection.column_exists?(:charges, :ChargeId)
  		add_column :charges, :ChargeId, :string
  	end
  	if !ActiveRecord::Base.connection.column_exists?(:charges, :ChargeIdName)
  		add_column :charges, :ChargeIdName, :string
  	end

  	if ActiveRecord::Base.connection.column_exists?(:charges, :Name)
  		remove_column :charges, :Name, :string
  	end
  	if ActiveRecord::Base.connection.column_exists?(:charges, :Description)
  		remove_column :charges, :Description, :string
  	end
  	if ActiveRecord::Base.connection.column_exists?(:charges, :InsertUserName)
  		remove_column :charges, :InsertUserName, :string
  	end
  	if ActiveRecord::Base.connection.column_exists?(:charges, :UpdateUserName)
  		remove_column :charges, :UpdateUserName, :string
  	end
  	if ActiveRecord::Base.connection.column_exists?(:charges, :UpdateDateTime)
  		remove_column :charges, :UpdateDateTime, :timestamp
  	end
  end
end
