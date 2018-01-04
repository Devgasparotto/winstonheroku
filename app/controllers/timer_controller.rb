class TimerController < ApplicationController
	include UserUtilityHelper
	include TicketPropertiesHelper
	include TimerHelper
	include TrialHelper
	include TicketPropertiesHelper

	#Trial Request Reminder

	def CreateTrialRequestReminder
		userId = params['messenger user id']
		user = GetUserBySenderId(userId).first
		if user.present?
   			currentTicket = GetCurrentTicket(user[:id]).first
   			if currentTicket.present?
   				ticketId = currentTicket[:id]
   				offenceDate = GetTicketOffenceDate(ticketId)
   				if !offenceDate.nil?
   					runAtDate = offenceDate + 10.days
					CreateTimer(userId, "TrialRequest", runAtDate)
   				end
   			end
		end

		render :html => "test"
	end

	def ExecuteTrialRequestTimers
		ExecuteTimerByTimerType("TrialRequest")
	end

	def DeleteTrialRequestTimers
		DeleteTrialByTimerType(params['messenger user id'], "TrialRequest")
		render :html => "test"
	end


	#Trial Date Reminder

	def CreateTrialDateReminder
		userId = params['messenger user id']
		user = GetUserBySenderId(userId).first
		if user.present?
			runAtDate = Time.now + 56.days #8 weeks to remind
			CreateTimer(userId, "TrialDate", runAtDate)
		end

		render :html => "test"
	end

	def ExecuteTrialDateTimers
		ExecuteTimerByTimerType("TrialDate")
	end

	def DeleteTrialDateTimers
		DeleteTrialByTimerType(params['messenger user id'], "TrialDate")
		render :html => "test"
	end


	#Disclosure Request Reminder

	def CreateDisclosureRequestReminder
		userId = params['messenger user id']
		user = GetUserBySenderId(userId).first
		if user.present?
   			currentTicket = GetCurrentTicket(user[:id]).first
   			if currentTicket.present?
   				ticketId = currentTicket[:id]
   				courtDate = GetCourtDateByTicketId(ticketId)
   				if !courtDate.nil?
   					runAtDate = courtDate - 63.days #reminder to request disclosure 9 weeks before trial
					CreateTimer(userId, "DisclosureRequest", runAtDate)
   				end
   			end
		end

		render :html => "test"
	end

	def ExecuteDisclosureRequestTimers
		ExecuteTimerByTimerType("DisclosureRequest")
	end

	def DeleteDisclosureRequestTimers
		DeleteTrialByTimerType(params['messenger user id'], "DisclosureRequest")
		render :html => "test"
	end


	#Prepare For Trial Reminder

	def CreatePrepareForTrialReminder
		userId = params['messenger user id']
		user = GetUserBySenderId(userId).first
		if user.present?
   			currentTicket = GetCurrentTicket(user[:id]).first
   			if currentTicket.present?
   				ticketId = currentTicket[:id]
   				courtDate = GetCourtDateByTicketId(ticketId)
   				if !courtDate.nil?
   					runAtDate = courtDate - 14.days #reminder to prepare for trial 2 weeks before trial
					CreateTimer(userId, "PrepareForTrial", runAtDate)
   				end
   			end
		end

		render :html => "test"
	end

	def ExecutePrepareForTrialTimers
		ExecuteTimerByTimerType("PrepareForTrial")
	end

	def DeletePrepareForTrialTimers
		DeleteTrialByTimerType(params['messenger user id'], "PrepareForTrial")
		render :html => "test"
	end


	#Disclosure Follow Up Date Reminder

	def CreateDisclosureFollowUpDateReminder
		userId = params['messenger user id']
		user = GetUserBySenderId(userId).first
		if user.present?
   			currentTicket = GetCurrentTicket(user[:id]).first
   			if currentTicket.present?
   				ticketId = currentTicket[:id]
   				courtDate = GetCourtDateByTicketId(ticketId)
   				if !courtDate.nil?
   					SetDisclosureRequestionSubmissionDateByTicketId(ticketId, Time.now)
					runAtDate = Time.now + 56.days
					CreateTimer(userId, "DisclosureFollowUpDate", runAtDate)
   				end
   			end
		end

		render :html => "test"
	end

	def ExecuteDisclosureFollowUpDateTimers
		ExecuteTimerByTimerType("DisclosureFollowUpDate")
	end

	def DeleteDisclosureFollowUpDateTimers
		DeleteTrialByTimerType(params['messenger user id'], "DisclosureFollowUpDate")
		render :html => "test"
	end
	
end
