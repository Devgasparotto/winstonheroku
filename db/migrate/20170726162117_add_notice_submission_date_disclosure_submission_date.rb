class AddNoticeSubmissionDateDisclosureSubmissionDate < ActiveRecord::Migration[5.0]
  def change
  	add_column :ticket_properties, :NOISubmissionDate, :timestamp
  	add_column :ticket_properties, :DRSubmissionDate, :timestamp
  end
end
