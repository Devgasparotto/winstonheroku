class AddAuthTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :auth_token, :string
    add_column :users, :token_expiry_datetime, :datetime
    add_index :users, :auth_token, unique: true
  end
end
