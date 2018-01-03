class RemoveColumnsFromTickets < ActiveRecord::Migration[5.0]
  def change
  	remove_column :tickets, :NoticeOfOffenceDate
		remove_column :tickets, :OfficerName
		remove_column :tickets, :MailingAddressId
		remove_column :tickets, :OffenceLocationAddressId
		remove_column :tickets, :ChargeTypeId
		remove_column :tickets, :CourtHouseId
  end
end
