class PromoCodeUniqueIndex < ActiveRecord::Migration[5.0]
  def change
  	add_index :promo_codes, :Code, unique: true
  end
end
