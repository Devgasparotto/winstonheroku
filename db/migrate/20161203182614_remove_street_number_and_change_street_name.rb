class RemoveStreetNumberAndChangeStreetName < ActiveRecord::Migration[5.0]
  def change
    remove_column :addresses, :StreetNumber
    rename_column :addresses, :StreetName, :StreetAddress
  end
end
