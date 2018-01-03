class ChangeTicketAddressIdToMailingAddressId < ActiveRecord::Migration[5.0]
  def change
    rename_column :tickets, :TicketAddressId, :MailingAddressId
  end
end
