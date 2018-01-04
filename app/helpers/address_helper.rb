module AddressHelper
	def SetDefendantMailingAddressByUserId(ticketId, streetNo, street, apt, municipality, province, postalCode)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		address = Address.find_by(:StreetNo => streetNo, :Street => street, :Apt => apt, :StreetNo => streetNo, :Municipality => municipality, :Province => province, :PostalCode => postalCode)

		if !address.present?
			address = Address.new
			address.StreetNo = streetNo
			address.Street = street
			address.Apt = apt
			address.Municipality = municipality
			address.Province = province
			address.PostalCode = postalCode
			address.save
		end

		# if !ticketProperties[:DefendantMailingAddressId].present?
		ticketProperties.DefendantMailingAddressId = address[:id]
		ticketProperties.save
		# else
		# 	address = Address.find_by(id: ticketProperties[:DefendantMailingAddressId])
		# 	address.StreetNo = streetNo
		# 	address.Street = street
		# 	address.Apt = apt
		# 	address.Municipality = municipality
		# 	address.Province = province
		# 	address.PostalCode = postalCode
		# 	address.save
		# end		
	end

	def GetMailingAddressByTicketId(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)

		if ticketProperties[:DefendantMailingAddressId].present?
			return address = Address.find_by(id: ticketProperties[:DefendantMailingAddressId])
		else
			return nil
		end
	end
end
