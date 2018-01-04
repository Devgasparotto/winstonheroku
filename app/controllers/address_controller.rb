class AddressController < ApplicationController
	include JsonHelper

	def GetCourthouseLocationForCurrentTicket
		user = GetUserByFacebookId(params['chatfuel user id'])
		userId = user.first[:id]
   		currentTicket = GetCurrentTicket(userId).first
   		ticketId = currentTicket[:id]
   		iconCode = GetTicketICONCode(ticketId)

   		if iconCode.present?
  			courthouse = Courthouse.find_by(ICON: iconCode)
  			if courthouse.present?
  				address = Address.find_by(id: courthouse[:CourtHouseAddressId])
  				if address.present?
 					googleMapURL = address[:GoogleMapAddressURL]
 					googleMapJSON = CreateSingleURLJSON(googleMapURL, "Click below to get the courthouse address", "Click Here")
 					puts googleMapJSON
 					render json: googleMapJSON
				else
		  			render html: ""
		  		end
  			else
	  			render html: ""
	  		end
  		else
  			render html: ""
  		end

	end
end
