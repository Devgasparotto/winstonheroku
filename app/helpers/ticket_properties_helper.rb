module TicketPropertiesHelper
	def SetTicketOffenceDate(ticketId, offenceDate)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.OffenceDate = offenceDate
		ticketProperties.save
	end

	def SetTicketDefendantName(ticketId, defendantName)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.DefendantName = defendantName
		ticketProperties.save
	end

	def SetTicketGivenName(ticketId, givenName)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.GivenName = givenName
		ticketProperties.save
	end

	def SetTicketFamilyName(ticketId, familyName)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.FamilyName = familyName
		ticketProperties.save
	end

	def SetTicketTelephoneNumber(ticketId, telephoneNo)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.TelephoneNo = telephoneNo
		ticketProperties.save
	end

	def SetTicketFaxNumber(ticketId, faxNo)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.FaxNo = faxNo
		ticketProperties.save
	end

	def SetTicketEmailAddress(ticketId, emailAddress)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.EmailAddress = emailAddress
		ticketProperties.save
	end

	def SetTicketICONCode(ticketId, iconCode)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.ICONCode = iconCode
		ticketProperties.save
	end

	def SetSpeedsByTicketId(ticketId, speeds)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.ChargeDesc = speeds
		ticketProperties.save
	end

	def SetChargeIdByTicketId(ticketId, chargeName)
		charge = Charge.find_by(:ChargeIdName => chargeName)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		ticketProperties.ChargeTypeId = charge[:id]
		ticketProperties.save
	end

	def SetDisclosureRequestionSubmissionDateByTicketId(ticketId, dRSubmissionDate)
 		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
 		ticketProperties.DRSubmissionDate = dRSubmissionDate
 		ticketProperties.save
 	end

	def GetSpeedsByTicketId(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		return ticketProperties[:ChargeDesc]
	end

	def GetTicketOffenceDate(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		return ticketProperties[:OffenceDate]
	end

	def GetTicketDefendantGivenName(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		return ticketProperties[:GivenName]
	end

	def GetTicketDefendantFamilyName(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		return ticketProperties[:FamilyName]
	end

	def GetTicketTelephoneNumber(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		return ticketProperties[:TelephoneNo]
	end

	def GetTicketICONCode(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		return ticketProperties[:ICONCode]
	end

	def GetTicketEmailAddress(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		return ticketProperties[:EmailAddress]
	end

	def GetDisclosureRequestName(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		return ticketProperties[:DisclosureRequestName]
	end
end
