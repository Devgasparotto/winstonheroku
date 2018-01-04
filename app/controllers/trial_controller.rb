class TrialController < ApplicationController
	include UserUtilityHelper
	require 'date'

	def CreateTrial
		render html: "Hi there"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])
		
		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			CreateNewTrialByTicketId(currentTicket[:id])
		end
	end

	def GetTrialForCurrentTicketByUserId(userId)
		currentUser = GetUserByFacebookId(params[:fb_id])
		
		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			trial = GetTrialByTicketId(currentTicket[:id])
			return trial
		end
		return nil #user doesn't exist
	end

	def GetTrialByTicketId(ticketId)
		#returns first trial found
		trial = Trial.where(TicketId: ticketId).first
		return trial
	end

	def CreateNewTrialByTicketId(ticketId)
		newTrial = Trial.new(TicketId: ticketId, IsComplete: 0)
		newTrial.save
	end

	def UpdateTrialCourthouse
		render html: "Test"
		currentUser = GetUserByFacebookId(params[:fb_id])

		if currentUser.exists?
			trial = GetTrialForCurrentTicketByUserId(currentUser[0][:id])

			if trial.present? #error occurs when using .exists, so using .present
				#TODO: adjust functionality for when ICON Code becomes a ticket property, assume a parameter for now
				courthouse = GetCourthouseByICONCode(params[:icon])
				trial.CourthouseId = courthouse[:id]
				trial.save
			end
		end
	end

	def GetCourthouseByICONCode(iconCode)
		return Courthouse.where(ICON: iconCode).first
	end

	def UpdateTrialCourtroom
		render html: "Test"
		currentUser = GetUserByFacebookId(params[:fb_id])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser[0][:id]).first
			trial = GetTrialByTicketId(currentTicket[:id])

			if trial.present?
				trial.Courtroom = params[:courtRoom]
				trial.save
			end
		end
	end

	def UpdateTrialCourtDate
		render html: "Test"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser[0][:id]).first
			trialTime = Time.parse(params[:TrialTime])
			trialDate = params[:TrialDate].to_date
			trialDateTime = DateTime.new(trialDate.year, trialDate.month, trialDate.day, trialTime.hour, trialTime.min)#, trialTime.sec, trialTime.zone)
			trial = GetTrialByTicketId(currentTicket[:id])

			if trial.present?
				trial.TrialDateTime = trialDateTime
				trial.save
			end
		end
	end


end
