class ChargeController < ApplicationController
	def saveChargeTypeForOffence		
		
		render html: "ChargeTypeUpdation"
		chargeType= params[:chargeType]
		id = params['messenger user id']
		if !id.nil? && !id.empty?
			currentUser = GetUserBySenderId(id)

			if currentUser.present?
				userId = currentUser.first[:id]
				currentTicket = GetCurrentTicket(userId).first
				ticketId = currentTicket[:id]
				if chargeType==='s128'
					chargeIdName="SPEEDING"
				elsif chargeType==='s144'	
					chargeIdName="RED_LIGHT"
				elsif chargeType==='s7'	
					chargeIdName="NO_STICKER"
				elsif chargeType==='s78.1'	
					chargeIdName="DISTRACTED_DRIVING"
				elsif chargeType==='s136'	
					chargeIdName="STOP_SIGN"
				elsif chargeType==='s142'	
					chargeIdName="UNSAFE_TURN"
				elsif chargeType==='s182'	
					chargeIdName="TRAFFIC_SIGN"	
				elsif chargeType==='s106'	
					chargeIdName="SEAT_BELT_VIOLATION"
				elsif chargeType==='s33'	
					chargeIdName="FAILURE_TO_SURRENDER"		
				end				 	
				
				charge=Charge.find_by(ChargeId: chargeType)
				ticketProperty = TicketProperty.find_by(TicketId: ticketId)
				ticketProperty.ChargeTypeId  = charge[:id]
				ticketProperty.save				
			end	
		end
		
	end
end
