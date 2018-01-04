module TicketHelper

	@@yes_arr = ["It's correct", "Yes", "Correct"]
	@@no_arr = ["It's wrong", "No", "It's blank", "Wrong"]

	def ConvertIsCorrectValue(reply)
		if(@@yes_arr.include?(reply))
			return 1
		elsif(@@no_arr.include?(reply))
			return 0
		else
			return 0
		end
	end

	def GetTicketOffenceNumber(ticketId)
		ticket = Ticket.find_by(:id => ticketId)
		return ticket[:OffenceNumber]
	end

	def SetTicketOffenceNumber(ticketId, offenceNumber)
		ticket = Ticket.find_by(:id => ticketId)
		ticket.OffenceNumber = offenceNumber
		ticket.save
	end

	def IsTicketCurrent(ticketId)
		ticket = Ticket.find_by(:id => ticketId)
		if !ticket.nil? && ticket[:IsCurrent]
			return true
		end
		return false	
	end
			
	def SetIconCode(ticketId, iconCode)
		ticketProp = TicketProperty.find_by(:id => ticketId)
		ticketProp.ICONCode = iconCode
		ticketProp.save
	end

	def GetUserByTicketId(ticketId)
		ticket = Ticket.where(id: ticketId).first
		return User.where(id: ticket[:UserId]).first
	end
			
	def GetTicketICONCode(ticketId)
		ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
		return ticketProperties[:ICONCode]
	end

	

end
