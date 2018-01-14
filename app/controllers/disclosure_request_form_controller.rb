class DisclosureRequestFormController < ApplicationController
	include CourthouseHelper
	include JsonHelper
	include TicketPropertiesHelper
	include DisclosureRequestFormHelper
	include TrialHelper
	include ChargeHelper
	require 'yaml'
	def GenerateDisclosureWebviewButton
		id = params['messenger user id']
		if !id.nil? && !id.empty?
			currentUser = GetUserBySenderId(id)
			if currentUser.present?
				subtitle = "Press Submit on the form when you are finished."
				buttonText = "Fill out form"
				url = "https://#{ENV['PRODUCTION_BASE_URL']}/requestForDisclosureForm?id=#{params['messenger user id']}"
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
def SendIconAndOffenceInChat
	correctedURL = URI.unescape(request.original_url)
	uri    = URI.parse(correctedURL)
	params = CGI.parse(uri.query) #NOTE: this allows the "%3D" to be interpretered as "=" in the query string params when displaying the webpage
	ticketId = ""
	iCode = ""
	if params['messenger user id'].nil? || params['messenger user id'].empty?
			iCode = "Icon Code and Offence No could not be retrieved."
	else
		idd = params['messenger user id'] 
		currentUser = GetUserBySenderId(idd).first
		if currentUser.present?
			userId = currentUser[:id]
				
			currentTicket = GetCurrentTicket(userId).first
			ticketId = currentTicket[:id]
		end
		iCode = GetTicketICONCode(ticketId)
	end
	json = CreateDoubleAttributeJSON("iconCode", iCode, "offenceNumber", GetTicketOffenceNumber(ticketId))
	render json: json
end	
	def GetImageUrl
		require 'google/cloud/vision'
		require 'googleauth'
		pictureURL = params['imageUrl']
		IO.copy_stream(open(pictureURL), '/home/utadmin/gcloud/ticketImage.jpg')
    	scopes =  ['https://www.googleapis.com/auth/cloud-platform','https://www.googleapis.com/auth/compute']
		authorization = Google::Auth.get_application_default(scopes)
		vision = Google::Cloud::Vision.new project: ENV['PROJECT_ID']
		image  = vision.image ENV['TICKET_IMAGE_PATH']
		image = image.text
		words = image.words
		finalOffenceNo = ""	
		count = 0
		offenceCount = 0
		tempIcon = ""
		tempIconCode = ""
		tempOffenceNumber = ""
		words.each_with_index {|val, index| 
	if (/\A\d+\z/.match(val)) && (val.to_s.length ==4) && (count <1)
		tempIconCode = val
		count = count + 1
	end	
	if /[0-9a-f]/.match(val)
		tempOffenceNumber = val
		val = val.to_s
		val = val[0...7]
	    if (/\A\d+\z/.match(val)) && (val.length == 7) && (offenceCount <1) 
	     finalOffenceNo = tempOffenceNumber
	     offenceCount = offenceCount + 1
		end
	end
	  
}
		correctedURL = URI.unescape(request.original_url)
		uri    = URI.parse(correctedURL)
		params = CGI.parse(uri.query) #NOTE: this allows the "%3D" to be interpretered as "=" in the query string params when displaying the webpage
		ticketId = ""
		if params['messenger user id'].nil? || params['messenger user id'].empty?
			#render html: "The user could not be verified"
		else
			idd = params['messenger user id'] 
			currentUser = GetUserBySenderId(idd).first
			if currentUser.present?
				userId = currentUser[:id]
				
				currentTicket = GetCurrentTicket(userId).first
				ticketId = currentTicket[:id]
			end
		end		
	if !tempIconCode.nil? || !tempIconCode.empty?
		SetTicketICONCode(ticketId,tempIconCode.to_s)
	end
	if !finalOffenceNo.nil? || !finalOffenceNo.empty? 
		SetTicketOffenceNumber(ticketId,finalOffenceNo.to_s)
	end 	
		render html: "hi"
	end	
	def index
		response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://www.messenger.com/"

		correctedURL = URI.unescape(request.original_url)
		uri    = URI.parse(correctedURL)
		params = CGI.parse(uri.query) #NOTE: this allows the "%3D" to be interpretered as "=" in the query string params when displaying the webpage
		puts params['id']
		puts params[:id]
		puts "HI"
		if params['id'].nil? || params['id'].empty?
			render html: "The user could not be verified"
		else
			puts "GOT HERE 1"
			currentUser = GetUserBySenderId(params['id']).first
			if currentUser.present?
				puts "GOT HERE 2"
				userId = currentUser[:id]
				currentTicket = GetCurrentTicket(userId).first
				ticketId = currentTicket[:id]
				iconCode = GetTicketICONCode(ticketId)
				ticketProperty = TicketProperty.find_by(TicketId: ticketId)
				charge = GetChargeByTicketId(ticketId)
				isSpeedingCharge = false
				if charge.present?
				  chargeCode = charge[:ChargeId]
				  chargeName = charge[:ChargeIdName]
				  #@chargeName = chargeName.camelize

				  offenceName = chargeName
				   if chargeCode == "s128"
				  		isSpeedingCharge = true
				  		@isSpeedingCharge = isSpeedingCharge
				   end		
				end
				displaySpeedFields = false
				 
				if isSpeedingCharge == true && iconCode.to_s == "4961"
					displaySpeedFields = true
					speeds = GetSpeedsByTicketId(ticketId)
					if !speeds.empty?
							speeds = speeds.to_s
							speeds = speeds.gsub(/(\[\"|\"\])/, '').split('", "')
							actualSpeed = speeds[0]
							maxSpeed = speeds[1]
					end		
				end			
				@displaySpeedFields = displaySpeedFields
				firstName = GetTicketDefendantGivenName(ticketId)
				lastName = GetTicketDefendantFamilyName(ticketId)	
				address = GetMailingAddressByTicketId(ticketId)
				if address.present?
					streetNo = address[:StreetNo]
					street = address[:Street]
					apt = address[:Apt]
					municipality = address[:Municipality]
					province = address[:Province]
					postalCode = address[:PostalCode]
				end
					offenceNo = currentTicket[:OffenceNumber]
					offenceDate = GetTicketOffenceDate(ticketId)
					@formFieldsMap = GetFormFieldsForIconCode();
					telephoneNo = GetTicketTelephoneNumber(ticketId)
					courtDate = GetCourtDateByTicketId(ticketId)
					courtRoom = GetCourtRoomByTicketId(ticketId)
					emailAddress = GetTicketEmailAddress(ticketId)
					faxNo = GetTicketFaxNoByTicketId(ticketId)
					officerNum = ""
					officerUnit = ""
					officerName = ""
					officerDetails = GetOfficerByTicketId(ticketId)
					if officerDetails.present?
						officerNum = officerDetails.first[:Number]
						officerUnit = officerDetails.first[:Division]
						officerName = officerDetails.first[:Name]
					end	
					#Pre-populate form
					@FB_APP_ID = ENV["FB_APP_ID"]
					@GOOGLE_MAPS_API_KEY = ENV['GOOGLE_MAPS_API_KEY']
					@id = params['id']
					@streetNo = FormatRailsJavascriptVariable(streetNo)
					@street = FormatRailsJavascriptVariable(street)
					@apt = FormatRailsJavascriptVariable(apt)
					@municipality = FormatRailsJavascriptVariable(municipality)
					@province = FormatRailsJavascriptVariable(province)
					@postalCode = FormatRailsJavascriptVariable(postalCode)
					@offence = FormatRailsJavascriptVariable(offenceName)
					@offenceNo = FormatRailsJavascriptVariable(offenceNo)
					@givenName = FormatRailsJavascriptVariable(firstName)
					@familyName = FormatRailsJavascriptVariable(lastName)
					@courtRoom = FormatRailsJavascriptVariable(courtRoom)
					@emailAddress = FormatRailsJavascriptVariable(emailAddress)
					@officerNumber = FormatRailsJavascriptVariable(officerNum.to_s)
					@officerDivision = FormatRailsJavascriptVariable(officerUnit)
					@officerName = FormatRailsJavascriptVariable(officerName)
					@actualSpeed = FormatRailsJavascriptVariable(actualSpeed)
					@maxSpeed = FormatRailsJavascriptVariable(maxSpeed)
					telephoneNoArray = FormatRailsJavascriptVariable(telephoneNo).split("-")
					faxNoArray = FormatRailsJavascriptVariable(faxNo).split("-")
					if telephoneNoArray.length > 2
						@telephoneNo1 = telephoneNoArray[0]
						@telephoneNo2 = telephoneNoArray[1]
						@telephoneNo3 = telephoneNoArray[2]
					elsif telephoneNoArray.length > 1
						@telephoneNo1 = telephoneNoArray[0]
						@telephoneNo2 = telephoneNoArray[1]
						@telephoneNo3 = ""
					elsif telephoneNoArray.length > 0
						@telephoneNo1 = telephoneNoArray[0]
						@telephoneNo2 = ""
						@telephoneNo3 = ""
					else
						@telephoneNo1 = ""
						@telephoneNo2 = ""
						@telephoneNo3 = ""
					end
					if faxNoArray.length > 2
						@faxNo1 = faxNoArray[0]
						@faxNo2 = faxNoArray[1]
						@faxNo3 = faxNoArray[2]
					elsif faxNoArray.length > 1
						@faxNo1 = faxNoArray[0]
						@faxNo2 = faxNoArray[1]
						@faxNo3 = ""
					elsif faxNoArray.length > 0
						@faxNo1 = faxNoArray[0]
						@faxNo2 = ""
						@faxNo3 = ""
					else
						@faxNo1 = ""
						@faxNo2 = ""
						@faxNo3 = ""
					end	
					if offenceDate.nil?
						@offenceDate = ""
					else
						@offenceDate = offenceDate.strftime("%Y-%m-%d")
					end

					if courtDate.nil?
						@courtDate = ""
					else
						@courtDate = courtDate.strftime("%Y-%m-%d")
						@courtTime = courtDate.strftime("%H:%M:%S")
					end

					@iconCodesArray = GetAllICONCodes()
					@chargeNamesArray = GetAllChargeCodes()
					if iconCode.nil?
						@iconCode = ""
					else
						@iconCode = iconCode
					end

					if params[:isBeta] == "true" #TODO: Replace these with custom servers for Beta, Prod, Dev, etc.
						@isBeta = true
					else
						@isBeta = false
					end
			else
				render html: "The user could not be verified"
			end
		end
	end	
	def SaveDisclosureRequestInformation
		currentUser = GetUserBySenderId(params[:id])
		#Save Information
		if currentUser.present?
			userId = currentUser.first[:id]
			currentTicket = GetCurrentTicket(userId).first
			ticketId = currentTicket[:id]

			givenName = params[:givenName]
			familyName = params[:familyName]
			streetNo = params[:streetNo]
			street = params[:street]
			apt = params[:apt]
			municipality = params[:municipality]
			province = params[:province]
			postalCode = params[:postalCode]
			offenceNo = params[:offenceNo]
			offenceDate = params[:offenceDate]
			iconCode = params[:iconCode]
			courtDate = params[:courtDate]
			courtRoom = params[:courtRoom]
			emailAddress = params[:emailAddress]
			officerNum = params[:officerNumber]
			officerUnit = params[:officerDivision]
			officerName = params[:officerName]
			telephoneNo = params[:telephoneNo]
			faxNum = params[:faxNo]
			offence = params[:offence]
 
			courtTime = params[:courtTime]
			actualSpeed = params[:actualSpeed]
			maxSpeed = params[:maxSpeed]
			speeds = Array[]
			speeds.push(actualSpeed)
			speeds.push(maxSpeed)
			if !courtDate.empty? && !courtTime.empty?
					courtDateTimeString = DateTime.parse(courtDate.to_s+" "+courtTime.to_s)
			end		
			SetSpeedsByTicketId(ticketId, speeds)
			SetDefendantMailingAddressByUserId(ticketId, streetNo, street, apt, municipality, province, postalCode)
			SetTicketOffenceNumber(ticketId, offenceNo)
			SetTicketICONCode(ticketId, iconCode)
			SetTicketOffenceDate(ticketId, offenceDate)
            SetCourtRoomByTicketId(ticketId, courtRoom)
			SetCourtDateByTicketId(ticketId, courtDateTimeString)
			SetTicketGivenName(ticketId, givenName)
			SetTicketFamilyName(ticketId, familyName)
			SetOfficerNumberByTicketId(ticketId, officerNum, officerUnit, officerName)
			SetOfficerNameByTicketId(ticketId, officerNum, officerUnit, officerName)
			SetOfficerDivisionByTicketId(ticketId, officerNum, officerUnit, officerName)
			SetTicketEmailAddressByTicketId(ticketId, emailAddress)
			SetTicketTelephoneNumber(ticketId, telephoneNo)
			SetTicketFaxNumber(ticketId, faxNum)
			SetChargeIdByTicketId(ticketId, offence)
		end
	end

	def DisclosureRequestForm
		senderId = params[:auth]
		baseDisclosureRequestFolderPath =  "#{ENV["BASE_DISCLOSURE_REQUEST_FOLDER_PATH"]}"
		pdfFilePath = "#{baseDisclosureRequestFolderPath}/UserForms/DisclosureRequestForm_#{senderId}.pdf" #TODO: change this to user form path

		fileNameToDisplay = "Disclosure Request Letter.pdf"

		File.open(pdfFilePath, 'r') do |f|
			send_data f.read, :type => "application/pdf"
		end
		filePathArray = [pdfFilePath]
		DeleteFiles(filePathArray)
	end

	def DisclosureRequestLetter
		senderId = params[:auth]
		baseDisclosureRequestFolderPath =  "#{ENV["BASE_DISCLOSURE_REQUEST_FOLDER_PATH"]}"
		pdfFilePath = "#{baseDisclosureRequestFolderPath}/UserForms/DisclosureRequestLetter_#{senderId}.pdf"
		fileNameToDisplay = "Disclosure Request Letter.pdf"

		File.open(pdfFilePath, 'r') do |f|
			send_data f.read, :type => "application/pdf"
		end
		filePathArray = [pdfFilePath]
		DeleteFiles(filePathArray)
	end

	def SendDisclosureRequestInChat
		require 'pdf_forms'
		require 'date'
		puts "A"
		senderId = params[:id][0] #NOTE: unsure why this is being received as an array instead of a string
		currentUser = GetUserBySenderId(senderId)
		if currentUser.present?
			userId = currentUser.first[:id]
			currentTicket = GetCurrentTicket(userId).first
			ticketId = currentTicket[:id]

			givenName = params[:givenName]
			familyName = params[:familyName]
			telephoneNo = params[:telephoneNo]
			streetNo = params[:streetNo]
			street = params[:street]
			apt = params[:apt]
			municipality = params[:municipality]
			province = params[:province]
			postalCode = params[:postalCode]
			offenceNo = params[:offenceNo]
			iconCode = params[:iconCode]
			isMobile = params[:isMobile]
			isBeta = params[:isBeta]	
			courtRoom = params[:courtRoom]
			courtTime = params[:courtTime]
			emailAddress = params[:emailAddress]
			officerNum = params[:officerNumber]
			officerUnit = params[:officerDivision]
			officerName = params[:officerName]	
			faxNo = params[:faxNo]
			actualSpeed = params[:actualSpeed]
			maxSpeed = params[:maxSpeed]
			offence = params[:offence]
			baseDisclosureRequestFolderPath =  "#{ENV["BASE_DISCLOSURE_REQUEST_FOLDER_PATH"]}"
			templatePDFFilePath = "#{baseDisclosureRequestFolderPath}/DisclosureRequestForms/Form#{iconCode}.pdf"
			pdfFilePath = "#{baseDisclosureRequestFolderPath}/UserForms/DisclosureRequestForm_#{senderId}.pdf"
			disclosureLetterPath = "#{baseDisclosureRequestFolderPath}/UserForms/DisclosureRequestLetter_#{senderId}.pdf"

			puts "B"
			#Delete files if they already exist
			filePathArray = [pdfFilePath, disclosureLetterPath]
			DeleteFiles(filePathArray)

			SetChargeIdByTicketId(ticketId, offence)

			#DISCLOSURE FORM

			#Format Offence Date, Court Date and Current Date
			offenceDate=params[:offenceDate]
			if !offenceDate.empty?
				offenceDate = Time.parse(offenceDate.to_s)
				offenceDate = offenceDate.strftime("%m/%d/%Y")
			end

			courtDate=params[:courtDate]
			courtDate = FormatRailsJavascriptVariable(courtDate.to_s)
			courtTime = FormatRailsJavascriptVariable(courtTime.to_s)
			if !courtDate.empty? && !courtDate.empty?
				courtDateTimeString = DateTime.parse(courtDate.to_s+" "+courtTime.to_s)
				courtTime = courtDateTimeString.strftime("%I:%M")
				isAmPm = courtDateTimeString.strftime("%p")
				trialTime = courtDateTimeString.strftime("%I:%M %p")
			end	
			isAm = " "
			isPm = " "
			if isAmPm == "AM"
               	 isAm = 'X'
               	 isPm = " "
            elsif isAmPm == "PM"
                 isPm = 'X'
                 isAm = ' '
            end

			currentDate = Time.now.strftime("%m/%d/%Y")
			
			#Format Charge
			charge = GetChargeByTicketId(ticketId)
			if charge.present?
				chargeCode = charge[:ChargeId]
				chargeName = charge[:ChargeIdName].humanize
				charge4961 = chargeName
				if	chargeCode == "s128" && iconCode.to_s == "4961"
					#For ICON Code 4961, the Disclosure Form requests the speed parameters for speeding tickets
					charge4961 = "#{chargeName} (#{actualSpeed} kph recorded in a #{maxSpeed} kph zone.)"
				end

				#Different Disclosure Request Letters are used for speeding and everything else
				if offence == "speeding"
					templateDisclosureLetterPath = "#{baseDisclosureRequestFolderPath}/DisclousreRequestLetterSpeeding/DisclosureRequestLetterSpeeding.pdf" #TODO: fix Disclousre name
				else
					templateDisclosureLetterPath = "#{baseDisclosureRequestFolderPath}/DisclosureRequestLetterNonSpeeding/DisclosureRequestLetterNonSpeeding.pdf"
				end
			end

			#Format Initials
			if !givenName.empty?
				firstInitial = givenName[0,1]
			end
			if !familyName.empty?
				lastInitial = familyName[0,1]
			end
			if(!firstInitial.nil? && !lastInitial.nil?)
				initials = firstInitial + lastInitial
			end	

			#Create Disclosure Form PDF
			pdftkFilePath = ENV['PDFTK_PATH']
			pdftk = PdfForms.new(pdftkFilePath)
			pdftk.fill_form templatePDFFilePath, pdfFilePath, {:givenName =>  givenName, :familyName => familyName, :offenceNo => offenceNo, :telephoneNo => telephoneNo, :faxNo => faxNo,
			 :offenceDate => offenceDate, :charge4961 => charge4961, :currentDate => currentDate, :courtDate => courtDate, :courtTime => courtTime, :officerNumber => officerNum, :officerDivision => officerUnit, :officerName => officerName, :courtroom => courtRoom, :chargeDescription => offence.humanize, :section => chargeCode, :initials => initials, :offence => offence.humanize, :requestedBy => givenName+" "+familyName, :isAM => isAm, :isPM => isPm, :trialTime => trialTime, :emailAddress => emailAddress},:flatten => true
			
			pdfFetchURL = "https://#{ENV["PRODUCTION_BASE_URL"]}/DisclosureRequestForm?auth=#{senderId}"
			error = SendPDFToUser(senderId, pdfFetchURL)
			if error
				return render :html => "ERROR"
			end

			#DISCLOSURE REQUEST LETTER

			#Format Courthouse Address
			if !iconCode.empty?
				#Get Courthouse address
				if Courthouse.exists?(ICON: iconCode)
					courthouse = Courthouse.where(ICON: iconCode).first
					if Address.exists?(id: courthouse[:CourtHouseAddressId])
						courthouseAddress = Address.where(id: courthouse[:CourtHouseAddressId]).first
						courtAddressLine1 = "#{courthouseAddress[:City]} - #{courthouseAddress[:CountyName]}"
						courtAddressLine2 = courthouseAddress[:StreetAddress]
						courtAddressLine3 = "#{courthouseAddress[:City]}, #{courthouseAddress[:Province]}"
						courtAddressLine4 = courthouseAddress[:PostalCode]
					end
				end
			end

			#Format Contact Info
			contactInfoLine1 = "#{givenName} #{familyName}"
			if apt == ""
				contactInfoLine2 = "#{streetNo} #{street}"
			else
				contactInfoLine2 = "#{streetNo} #{street}, Apt. #{apt}"
			end
			contactInfoLine3 = "#{municipality}, #{province}"
			contactInfoLine4 = postalCode
			
			#Create Disclosure Request Letter PDF
			pdftk = PdfForms.new(pdftkFilePath)
			pdftk.fill_form templateDisclosureLetterPath, disclosureLetterPath, {
				:courtAddressLine1 => courtAddressLine1, :courtAddressLine2 => courtAddressLine2, :courtAddressLine3 => courtAddressLine3, :courtAddressLine4 => courtAddressLine4,
				:contactInfoLine1 => contactInfoLine1, :contactInfoLine2 => contactInfoLine2, :contactInfoLine3 => contactInfoLine3, :contactInfoLine4 => contactInfoLine4,
				:offenceNo => offenceNo, :offenceDate => offenceDate, :currentDate => currentDate, :courtDate => "#{courtDate}."},
				:flatten => true

			pdfFetchURL = "https://#{ENV["PRODUCTION_BASE_URL"]}/DisclosureRequestLetter?auth=#{senderId}"
			error = SendPDFToUser(senderId, pdfFetchURL)
			if error
				return render :html => "ERROR"
			else
				return render :html => "OK"
			end
		end
	end

	def DeleteFiles(filePathArray)
		filePathArray.each do |filePath|
			if File.exist?(filePath)
				File.delete(filePath)
	   		end
		end
	end

	def SendPDFToUser(senderId, fileURL)
		require 'net/http'
		require 'uri'
		require 'json'

		accessToken = ENV["FB_PAGE_ACCESS_TOKEN"]
		baseURI = "#{ENV["FB_GRAPH_API_BASE_URI"]}"
		
		uri = URI.parse("#{baseURI}?access_token=#{accessToken}")
		request = Net::HTTP::Post.new(uri)
		request.content_type = "application/json"
		request.body = JSON.dump({
		  "recipient" => {
		    "id" => senderId
		  },
		  "message" => {
		    "attachment" => {
		      "type" => "file",
		      "payload" => {
		        "url" => fileURL
		      }
		    }
		  }
		})

		req_options = {
		  use_ssl: uri.scheme == "https",
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		  http.request(request)
		end
		
		puts response

		if response.message == "OK"
			return false
		else
			return true
		end
	end



	def FormatDisclosureRequestPDF
		require 'pdf_forms'
		require 'date'

		senderId = params[:psid]
		keyId = params[:keyId]

		givenName = params[:givenName]
		familyName = params[:familyName]
		telephoneNo = params[:telephoneNo]
		streetNo = params[:streetNo]
		street = params[:street]
		apt = params[:apt]
		municipality = params[:municipality]
		province = params[:province]
		postalCode = params[:postalCode]
		offenceNo = params[:offenceNo]
		iconCode = params[:iconCode]
		isMobile = params[:isMobile]

		offenceDateTime = DateTime.parse(params[:offenceDate])
		offenceDate = offenceDateTime.strftime("%B %d, %Y")

		courtDateTime = DateTime.parse(params[:courtDate])
		courtDate = "#{courtDateTime.strftime("%B %d, %Y")}."

		currentDate = Time.now.strftime("%B %d, %Y")

		if !iconCode.empty?
			#Get Courthouse address
			if Courthouse.exists?(ICON: iconCode)
				courthouse = Courthouse.where(ICON: iconCode).first
				if Address.exists?(id: courthouse[:CourtHouseAddressId])
					courthouseAddress = Address.where(id: courthouse[:CourtHouseAddressId]).first
					courtAddressLine1 = "#{courthouseAddress[:City]} - #{courthouseAddress[:CountyName]}"
					courtAddressLine2 = courthouseAddress[:StreetAddress]
					courtAddressLine3 = "#{courthouseAddress[:City]}, #{courthouseAddress[:Province]}"
					courtAddressLine4 = courthouseAddress[:PostalCode]
				end
			end
		end

		contactInfoLine1 = ""
		contactInfoLine2 = "#{streetNo} #{street}"
		contactInfoLine3 = "#{municipality}, #{province}"
		contactInfoLine4 = postalCode

		filePath = "documents/DisclosureRequestLetters/DisclosureRequestLetter_#{keyId}.pdf"
		pdftk = PdfForms.new('/usr/bin/pdftk') #change to environment variable
		pdftk.fill_form "documents/DisclosureRequestLetters/DisclosureRequestLetter.pdf", filePath, {:givenName =>  givenName, :familyName => familyName, 
			 :offenceDate => offenceDate, :currentDate => currentDate, :courtDate => courtDate, :courtTime => courtTime},:flatten => true


		SendEmailWithDisclosureRequestLetterPDF(keyId, filePath)
	end

	def SendEmailWithDisclosureRequestLetterPDF(keyId, filePath)
		PdfMailer.email_disclosure_request_letter(keyId, filePath).deliver_now
	end

	def FormatRailsJavascriptVariable(variableValue)
		if variableValue.nil? || variableValue.empty?
			variableValue = ""
		end
		return variableValue
	end

end

