class DatetimeInputController < ApplicationController
	include JsonHelper

	def index
		response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://www.messenger.com/"

		correctedURL = URI.unescape(request.original_url)
		uri    = URI.parse(correctedURL)
		params = CGI.parse(uri.query)

		if params['id'].nil? || params['id'].empty?
			render html: "The user could not be verified"
		else
			currentUser = GetUserBySenderId(params['id']).first
			if currentUser.present?
				@headerText = nil
				@dateType = params['dateType'][0]
				if @dateType == "trialDate"
					@headerText = "Trial Date & Time"
				elsif @dateType == "noiSubmission"
						@headerText = "Enter NOI Date"
				elsif @dateType == "disclosureSubmission"
						@headerText = "Enter Disclosure Date"
				elsif @dateType == "earlyResolution"
						@headerText = "Enter Early Resolution Date"
				end
				
				@id = params['id']
			else
				render html: "The user could not be verified"
			end
		end
	end

	def saveDateTime
		currentUser = GetUserBySenderId(params[:id][0]).first
		if currentUser.present?
			userId = currentUser[:id]			
			currentTicket = GetCurrentTicket(userId).first			
			ticketId = currentTicket[:id]
			formType = params[:formType]	
			dateTime = params[:timestamp]
			
			if (formType == "noiSubmission")
				ticketProperties = TicketProperty.find_by(:TicketId => ticketId)				
				ticketProperties.NOISubmissionDate=dateTime	
				ticketProperties.save
			end
			if (formType == "disclosureSubmission")
				ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
				ticketProperties.DRSubmissionDate = dateTime
				ticketProperties.save
			end	
			if (formType == "trialDate")
				trials = Trial.find_by(:TicketId => ticketId)
				trials.TrialDateTime = dateTime
				trials.save
			end
			if (formType == "earlyResolution")
				puts "A"
				ticketProperties = TicketProperty.find_by(:TicketId => ticketId)
				ticketProperties.EarlyResolutionDateTime = dateTime
				ticketProperties.save
			end
		end
	end

	def GenerateDateTimeInputWebviewButton
		id = params['messenger user id']
		if !id.nil? && !id.empty?
			currentUser = GetUserBySenderId(id)
			if currentUser.present?
				subtitle = "Press Save on the form when you are finished."
				buttonText = "Enter date"
				url = "https://#{ENV['PRODUCTION_BASE_URL']}/enterDateTime?id=#{id}&dateType=#{params['dateType']}"
				fallbackURL = "https://www.google.ca"
				
				webviewJSON = CreateWebviewURLJSON(url, subtitle, buttonText, fallbackURL)
				render json: webviewJSON
			else
				render html: "User not verified"
			end
		else
			render html: "User not verified"
		end
	end

	def UpdateNoticeOfIntentionSubmissionDate
		currentUser = GetUserBySenderId(params['messenger user id'])
		if currentUser.present?
			userId = currentUser.first[:id]
			currentTicket = GetCurrentTicket(userId).first
			ticketId = currentTicket[:id]
			noticeSubmissionDateInput = params[:noticeSubmissionDate].to_date
			noticeSubmissionDate = DateTime.new(noticeSubmissionDateInput.year, noticeSubmissionDateInput.month, noticeSubmissionDateInput.day, 0, 0, 0)
			ticketProperty = TicketProperty.find_by(TicketId: currentTicket[:id])
   			ticketProperty.NOISubmissionDate = noticeSubmissionDate
   			ticketProperty.save
		end
	end

	def UpdateDisclosureRequestSubmissionDate
		currentUser = GetUserBySenderId(params['messenger user id'])
		if currentUser.present?
			userId = currentUser.first[:id]
			currentTicket = GetCurrentTicket(userId).first
			ticketId = currentTicket[:id]
			disclosureSubmissionDateInput = params[:disclosureRequestSubmissionDate].to_date
			disclosureSubmissionDate = DateTime.new(disclosureSubmissionDateInput.year, disclosureSubmissionDateInput.month, disclosureSubmissionDateInput.day, 0, 0, 0)
			ticketProperty = TicketProperty.find_by(TicketId: currentTicket[:id])
   			ticketProperty.DRSubmissionDate = disclosureSubmissionDate
   			ticketProperty.save
		end
	end
	
end
