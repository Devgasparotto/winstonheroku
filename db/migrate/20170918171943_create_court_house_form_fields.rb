class CreateCourtHouseFormFields < ActiveRecord::Migration[5.0]
  def change
    create_table :court_house_form_fields do |t|
      t.integer :courtId
      t.string :fieldNames

      t.timestamps
    end
  end
end
