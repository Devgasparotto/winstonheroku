class TicketController < ApplicationController

	include UserUtilityHelper
	include TicketHelper
	require 'date'

	def CreateTicket
		currentUser = GetUserByFacebookId(params['messenger user id'])
		if currentUser.exists?
			#Only creating ticket for first UserId found with corresponding FacebookId
			CreateNewTicket(currentUser[0][:id])
		end
		render html: "success"
	end	

	def UpdateTicketAddressByFacebookId
		render html: "Hi there"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])

		if currentUser.exists?

			# find address by unique key determined by 
			# StreetAddress, City, Province, PostalCode
			currentMailAddr = Address.find_by(StreetAddress: params[:StreetAddress], City: params[:City], Province: params[:Province], PostalCode: params[:PostalCode])

			if currentMailAddr.nil?
				currentMailAddr = Address.new(:StreetAddress => params[:StreetAddress], :PostalCode => params[:PostalCode], :City => params[:City], :Province => params[:Province], :PostalCode => params[:PostalCode])
				currentMailAddr.save
			end

			# Added MailingAddressId to tickets table
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			UpdateTicketProperty(currentTicket[:id], :DefendantMailingAddressId, currentMailAddr.id)
			# ticketProperty = TicketProperty.find_by(:TicketId => currentTicket[:id])
			# ticketProperty.DefendantMailingAddressId = currentMailAddr.id
			# ticketProperty.save
		end
	end

	def UpdateTicketOffenceNumber
		render html: "Hi there"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			currentTicket.OffenceNumber = params[:OffenceNumber]
			currentTicket.save
		end
	end

	def UpdateTicketOffenceDate
		render html: "Hi there"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			ticketProperty = TicketProperty.find_by(TicketId: currentTicket[:id])
			#TODO: input validation that OffenceDate is a DateTime is required
			ticketProperty.NoticeOfOffenceDate = params[:OffenceDate]
			ticketProperty.save
		end
	end

	def UpdateTicketCourthouse
		#TODO: Remove this code
		render html: "Hi there"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			courthouse = GetCourtHouseByICONCode(params[:iconCode])
			if courthouse.exists?
				trial = Trials.where(TicketId: currentTicket[:id])
				if trial.exists?
					trial.CourthouseId = courthouse[0][:id]
					trial.save
				end
			end
		end
	end

	def UpdateTicketName
		render html: "Hi there"
		currentUser = GetUserByFacebookId(params[:fb_id])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser[0][:id]).first
			currentTicket.TicketFirstName = params[:defendantFirstName]
			currentTicket.TicketLastName = params[:defendantLastName]
			currentTicket.save
		end
	end

	def UpdateCourtDate
		render html: "Test"
		currentUser = GetUserByFacebookId(params[:fb_id])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser[0][:id]).first
			trialTime = Time.parse(params[:courtTime])
			trialDate = params[:courtDate].to_date
			trialDateTime = DateTime.new(trialDate.year, trialDate.month, trialDate.day, trialTime.hour, trialTime.min, trialTime.sec, trialTime.zone)
			trial = GetTrialByTicketId(currentTicket[:id])

			if !trial.exists?
				newTrial = Trial.new(TicketId: currentTicket[:id], TrialDateTime: trialDateTime)
				newTrial.Courtroom = params[:courtRoom]
				newTrial.save
			else
				trial.Courtroom = params[:courtRoom]
				trial.TrialDateTime = trialDateTime
				trial.save
			end
		end
	end

	def UpdateOfficer
		render html: "Test"
		currentUser = GetUserByFacebookId(params[:fb_id])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser[0][:id]).first
			officer = GetOfficerByTicketId(currentTicket[:id])
			if !officer.exists?
				newOfficer = Officer.new(TicketId: currentTicket[:id], Name: params[:officerName], Number: params[:officerNumber], Division: params[:officerDivision])
				newOfficer.save
			else
				officer.Name = params[:officerName]
				officer.Number = params[:officerNumber]
				officer.Division = params[:officerDivision]
				officer.save
			end
		end
	end

	def UpdateTicketAttributeByFacebookId 
		render html: "Hi there"
		currentUser = GetUserByFacebookId(params[:fb_id])

		if currentUser.exists?
			#Only updating attribute of first
			currentTicket = GetCurrentTicket(currentUser[0][:id])
			UpdateTicketAttribute(currentTicket[0][:id], params[:attrib_name], params[:attrib_value])
		end
	end

	#Move to new Courthouse controller
	def TrialRequestSubmissionLocation
		render html: "Hi there"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser[0][:id]).first
			trial = GetTrialByTicketId(currentTicket[:id]).first
			courtHouse = Courthouse.where(id: trial[:CourthouseId])
			if courtHouse.exists?
				courtHouseAddress = Address.where(id: courtHouse[0].CourtHouseAddressId)
				messageText = "You now have everything you need to submit. Please take your Marked Ticket and Notice of Attention to Appear Form to the following courthouse."
				SendCourtHouseLocationMessage(currentUser[0][:SenderId], messageText, courtHouseAddress[0][:GoogleMapAddressURL])
			end
		end
	end

	def UpdateTicketCharge
		render html: "test"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])

		if currentUser.exists?
			charge = Charge.where(Name: params[:Infraction]).first
			if charge.present?
				currentTicket = GetCurrentTicket(currentUser.first[:id]).first
				UpdateTicketProperty(currentTicket[:id], 'ChargeTypeId', charge[:id])
			end
		end
	end

	def UpdateDisclosureRequestName
		render html: "test"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])

		if currentUser.exists?
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			UpdateTicketProperty(currentTicket[:id], 'DisclosureRequestName', params[:DisclosureRequestName])
		end
	end

	def UpdateIsOffenceDateCorrect
		render html: "test"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])

		if currentUser.exists?
			val = ConvertIsCorrectValue(params[:IsOffenceDateCorrect])
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			UpdateTicketProperty(currentTicket[:id], :IsOffenceDateCorrect, val)
		end
	end

	def UpdateIsDefendantNameCorrect
		render html: "test"
		currentUser = GetUserByFacebookId(params["chatfuel user id"])

		if currentUser.exists?
			val = ConvertIsCorrectValue(params[:IsDefendantNameCorrect])
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			UpdateTicketProperty(currentTicket[:id], :IsDefendantNameCorrect, val)
		end
	end

	def UpdateIsLanguageInterpreterRequired
		render html: "test"
		currentUser = GetUserByFacebookId(params["chatfuel user id"])

		if currentUser.exists?
			val = ConvertIsCorrectValue(params[:IsLanguageInterpreterRequired])
			currentTicket = GetCurrentTicket(currentUser.first[:id]).first
			UpdateTicketProperty(currentTicket[:id], :IsLanguageInterpreterRequired, val)
		end
	end
	
	def index
		
		
	end
end
