class CreateTicketProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_properties do |t|
    	t.timestamp :OffenceDate
    	t.boolean 	:IsOffenceDateCorrect
    	t.timestamp :NoticeOfOffenceDate
    	t.boolean 	:IsDefendantNameCorrect
    	t.integer 	:DefendantMailingAddressId
    	t.boolean 	:IsLanguageInterpreterRequired
    	t.string 		:LanguageToInterpretTo
    	t.integer 	:CourtHouseId
    	t.integer 	:ICONCode
    	t.integer		:ChargeTypeId
    	t.string		:InsertUserName
    	t.timestamp	:InsertDateTime
    	t.string 		:UpdateUserName
    	t.timestamp :UpdateDateTime
    end
  end
end
