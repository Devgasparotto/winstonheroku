class CourtDateController < ApplicationController
	include UserUtilityHelper
	include TicketHelper
	include JsonHelper

	def GetCourtDate
		userId = params['messenger user id']
		user = GetUserBySenderId(userId).first
		if user.present?
			currentTicket = GetCurrentTicket(user[:id]).first
			if  currentTicket.present?
				trial = Trial.where(TicketId: currentTicket[:id]).first	
				if trial.present?
					trialDateTime = trial[:TrialDateTime]
					if trialDateTime.present?
						trialDateFormatted = trialDateTime.strftime("%A %B %d at %I:%M %p")
						json = CreateSingleAttributeJSON("trialDateTime", "#{trialDateFormatted}")
						puts json
						return render json: json
					end
			    end	   
			end
		end
		render html: "test"
	end
end
