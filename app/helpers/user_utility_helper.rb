module UserUtilityHelper

	def UserFBIdExists(fb_id)
		if User.where(FacebookId: fb_id).exists?
			return true
		end
		return false
	end

	def GetUserByFacebookId(fb_id)
		user = User.where(FacebookId: fb_id)
		return user
	end

	def GetUserBySenderId(senderId)
		user = User.where(SenderId: senderId)
		return user
	end

	def GetSenderIdByFacebookId(fb_id)
		user = GetUserByFacebookId(fb_id)
		return user[0][:SenderId]
	end


	def ParseProfilePicURL(fullProfilePicURL)
		profilePicURL = fullProfilePicURL[0..fullProfilePicURL.index('.jpg')]
		profilePicURL = profilePicURL[profilePicURL.rindex('/') + 1..profilePicURL.length - 1]
		return profilePicURL
	end


	#TODO: move ticket helpers to new class
	def CreateNewTicket(userId)
		SetPreviousTicketsToNotCurrent(userId)
		newTicket = Ticket.new(UserId: userId, IsCurrent: 1)
		newTicket.save
		CreateNewTicketProperty(newTicket.id)
	end

	def CreateNewTicketProperty(ticketId)
		newProperty = TicketProperty.new(TicketId: ticketId)
		newProperty.save
	end

	def SetPreviousTicketsToNotCurrent(userId)
		userTickets = Ticket.where(UserId: userId)
		userTickets.each do |oldTicket|
			oldTicket.update(IsCurrent: 0)
		end
	end

	def CreateNewTicketAttributes(ticketId)
		UpdateTicketAttribute(ticketId, "IsOffenceDateCorrect", "0")
		UpdateTicketAttribute(ticketId, "OffenceDate", "0")
		UpdateTicketAttribute(ticketId, "IsDefendantNameCorrect", "0")
		UpdateTicketAttribute(ticketId, "DefendantName", "0")
		UpdateTicketAttribute(ticketId, "MailingAddress", "0")
		UpdateTicketAttribute(ticketId, "OffenceNumber", "0")
		UpdateTicketAttribute(ticketId, "ICONCode", "0")
		UpdateTicketAttribute(ticketId, "IsLanguageInterpreterRequired", "0")

	end

	def UpdateTicketProperty(ticketId, propertyName, propertyValue)
		ticketProperty = TicketProperty.find_by(TicketId: ticketId)
		if ticketProperty.present?
			puts "Updating property"
			ticketProperty.update(propertyName => propertyValue)
		else
			puts "Ticket property does not exist"
		end
	end
	
	def UpdateTicketAttribute(ticketId, attributeName, attributeValue)
		referenceTicketAttribute = TicketAttribute.where(TicketId: ticketId, AttributeName: attributeName)
		if referenceTicketAttribute.exists?
			#Update value
			puts "Updating attribute"
			referenceTicketAttribute.update(AttributeValue: attributeValue)
		else
			#Create new record
			puts "Updating new attribute"
			newTicketAttribute = TicketAttribute.new(TicketId: ticketId, AttributeName: attributeName, AttributeValue: attributeValue)
			newTicketAttribute.save
		end

	end

	def GetCurrentTicket(userId)
		currentTicket = Ticket.where(UserId: userId, IsCurrent: 1)
		return currentTicket
	end

	# Delete this when finished changing attributes to properties
	# Delete in next commit/pull request, still needs to test that removal doesn't break stuff...
	# def GetTicketAttributesByFacebookId(fb_id)
	# 	currentUser = GetUserByFacebookId(fb_id)
	# 	currentTicketAttributes = GetTicketAttributesByUserId(currentUser[0][:id])
	# 	return currentTicketAttributes
	# end

	# # Delete this when finished changing attributes to properties
	# def GetTicketAttributesByUserId(userId)
	# 	currentTicket = GetCurrentTicket(userId)
	# 	currentTicketAttributes = GetTicketAttributesByTicketId(currentTicket[0][:id])
	# end

	# # Delete this when finished changing attributes to properties
	# def GetTicketAttributesByTicketId(ticketId)
	# 	currentTicketAttributes = TicketAttribute.where(TicketId: ticketId)
	# 	return currentTicketAttributes
	# end

	def GetTrialByTicketId(ticketId)
		#TODO: implement below
		# In the instance that a ticket has multiple trials associated with it:
		# -Get the Trial with IsComplete = 0.
		# -If there are still multiple trials with IsComplete=0, then select the Trial with the next TrialDateTime that is closest to and greater than the current Date (next available date)
		# -Create trigger that sets IsComplete to 1 when TrialDateTime has passed

		trial = Trial.where(TicketId: ticketId)
		return trial
	end

	def GetCourtDateByTicketId(ticketId)
		#TODO: Test this
		trial = Trial.where(TicketId: ticketId).first
		courtDate = trial[:TrialDateTime]
		return courtDate
	end

	def GetCourtRoomByTicketId(ticketId)
		trial = Trial.where(TicketId: ticketId).first
		courtRoom = trial[:Courtroom]
		return courtRoom
	end

	def GetOfficerByTicketId(ticketId)
		officer = Officer.where(TicketId: ticketId)
		return officer
	end

	def GetCourtHouseByICONCode(iconCode)
		courthouse = Courthouse.where(ICON: iconCode)
		return courthouse
	end

	#Move to Timer module
	def SendMessage(senderId, message)
		#headers = {"Content-Type" => "application/json"}


		#TODO: put page access token in config file
		accessToken = ENV["FB_PAGE_ACCESS_TOKEN"]
		baseURI = "#{ENV["FB_GRAPH_API_BASE_URI"]}"

		params ={
			recipient: {id: senderId},
			message: {text: message},
			access_token: accessToken
		}

		RestClient.post baseURI, params.to_json, content_type: 'application/json', accept: 'application/json'
	end

	#Move to Courthouse module
	def SendCourtHouseLocationMessage(senderId, messageText, url)
		
		courtHouseLocationButton = CreateButtonWithURLPayload("Courthouse Location", url)
		buttons = Array.new
		buttons.push(courtHouseLocationButton)
		jsonPayload = {
			"template_type":"button",
			"text":messageText,
			"buttons":buttons
		}

		jsonMessage = {
			"attachment":{
				"type":"template",
				"payload":jsonPayload
			}
		}
		
		SendURLButtonMessageToUser(senderId, jsonMessage)
	end

	def CreateButtonWithURLPayload(buttonText, url)
		jsonButton = {
			"type":"web_url",
			url: url,
			"title":buttonText
		}

		#TODO: verify payload format is correct
		return jsonButton
	end

	def SendURLButtonMessageToUser(senderId, jsonMessage)
		#TODO: put accessToken and baseURI in a config file
		accessToken = ENV["FB_PAGE_ACCESS_TOKEN"]
		baseURI = "#{ENV["FB_GRAPH_API_BASE_URI"]}"

		params ={
			recipient: {id: senderId},
			message: jsonMessage,
			access_token: accessToken
		}
		
		RestClient.post baseURI, params.to_json, content_type: 'application/json', accept: 'application/json'
	end

	def AuthenticateToken(token)
		user = GetCurrentUserByToken(token)
		if user.present?
			currentTime = Time.now
			if currentTime < user.token_expiry_datetime
				#user.token_expiry_datetime = currentTime #TODO: Find a way to not authorize token for chatfuel
				#user.save
				return true
			end
		end
		return false
	end

	def GetCurrentUserByToken(token)
		return User.find_by(:auth_token => token)
	end

end
