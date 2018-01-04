module DisclosureRequestFormHelper


	def SetOfficerNameByTicketId(ticketId, officerNum, officerDivision, officerName)
		officer = Officer.find_by(:TicketId => ticketId)
			if(!officer.present?)
				officer = Officer.new(TicketId: ticketId, Number: officerNum, Division: officerDivision, Name: officerName)
				officer.save
			else	
				officer.Name = officerName
				officer.save
			end	
	end

	def SetOfficerNumberByTicketId(ticketId, officerNum, officerDivision, officerName)
		officer = Officer.find_by(:TicketId => ticketId)
			if(!officer.present?)
				officer = Officer.new(TicketId: ticketId, Number: officerNum, Division: officerDivision, Name: officerName)
				officer.save
			else	
				officer.Number = officerNum
				officer.save
			end	
	end


	def SetOfficerDivisionByTicketId(ticketId, officerNum, officerDivision, officerName)
		officer = Officer.find_by(:TicketId => ticketId)
			if(!officer.present?)
				officer = Officer.new(TicketId: ticketId, Number: officerNum, Division: officerDivision, Name: officerName)
				officer.save
			else	
				officer.Division = officerDivision
				officer.save
			end	
	end

	def SetTicketEmailAddressByTicketId(ticketId, emailAddress)
		tktProperty = TicketProperty.find_by(:TicketId => ticketId)
		tktProperty.EmailAddress = emailAddress
		tktProperty.save
	end

	def SetTicketFaxNoByTicketId(ticketId, faxNo)
		tktProperty = TicketProperty.find_by(:TicketId => ticketId)
		tktProperty.FaxNo = faxNo
		tktProperty.save
	end

	def GetTicketFaxNoByTicketId(ticketId)
		tktProperty = TicketProperty.find_by(:TicketId => ticketId)
		return tktProperty[:FaxNo]
	end

	def GetChargeByTicketId(ticketId)
		tktProperty = TicketProperty.find_by(:TicketId => ticketId)
		chargeId = tktProperty[:ChargeTypeId]
		charge=Charge.find_by(id: chargeId)
		return charge
	end

    def GetFormFieldsForIconCode()
    	formFieldsHash = Hash.new 
    	formFieldsHash["4860"] = ['familyName', 'givenName', 'offence','offenceNo', 'offenceDate', 'courtDate', 'courtroom', 'courtTime',  'officerName', 'officerNumber', 'officerDivision', 'telephoneNo']
		formFieldsHash["4862"] = ["familyName", "givenName", 'offence',"offenceNo", "offenceDate", "courtDate", "courtroom", "courtTime",  "officerName", "officerNumber", "officerDivision", "telephoneNo"]
		formFieldsHash["4863"] = ["familyName", "givenName", 'offence',"offenceNo", "offenceDate", "courtDate", "courtroom", "courtTime",  "officerName", "officerNumber", "officerDivision", "telephoneNo"]
		formFieldsHash["3160"] = ["familyName", "givenName", 'offence',"telephoneNo", "faxNo", "offenceNo", "offenceDate", "courtDate", "courtroom", "courtTime",  "officerName", "officerNumber", "officerDivision"]
		formFieldsHash["4961"] = ["familyName", "givenName", 'offence',"offenceNo", "courtDate", "courtroom", "courtTime",  "officerNumber",  "telephoneNo", "faxNo", "emailAddress"]
		return formFieldsHash
    end	
end
