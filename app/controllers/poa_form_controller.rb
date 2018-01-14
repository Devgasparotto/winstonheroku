class PoaFormController < ApplicationController
	include CourthouseHelper
	include JsonHelper


	def GenerateNOIWebviewButton
		id = params['messenger user id']
		if !id.nil? && !id.empty?
			currentUser = GetUserBySenderId(id)
			if currentUser.present?
				subtitle = "Press Submit on the form when you are finished."
				buttonText = "Fill out form"
				
				url = "https://#{ENV['PRODUCTION_BASE_URL']}/noticeOfIntentionForm?id=#{params['messenger user id']}"
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

	def notice_of_intention_form
		response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://www.messenger.com/"

		correctedURL = URI.unescape(request.original_url)
		uri    = URI.parse(correctedURL)
		params = CGI.parse(uri.query) #NOTE: this allows the "%3D" to be interpretered as "=" in the query string params when displaying the webpage

		if params['id'].nil? || params['id'].empty?
			render html: "The user could not be verified"
		else
			currentUser = GetUserBySenderId(params['id']).first
     		if currentUser.present?	
				userId = currentUser[:id]
				currentTicket = GetCurrentTicket(userId).first
				ticketId = currentTicket[:id]
				puts "TICKET ID: #{ticketId}"
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
				iconCode = GetTicketICONCode(ticketId)
				offenceDate = GetTicketOffenceDate(ticketId)
				firstName = GetTicketDefendantGivenName(ticketId)
				lastName = GetTicketDefendantFamilyName(ticketId)
				telephoneNo = GetTicketTelephoneNumber(ticketId)
				languageToInterpretTo = GetLanguageToInterpretToByTicketId(ticketId)
				trialLanguage = GetTrialLanguageByTicketId(ticketId)
				emailAddress = GetTicketEmailAddress(ticketId)

				@GOOGLE_MAPS_API_KEY = ENV['GOOGLE_MAPS_API_KEY']
				 
				#Pre-populate form
				@FB_APP_ID = ENV["FB_APP_ID"]
				@id = params['id']
				@streetNo = FormatRailsJavascriptVariable(streetNo)
				@street = FormatRailsJavascriptVariable(street)
				@apt = FormatRailsJavascriptVariable(apt)
				@municipality = FormatRailsJavascriptVariable(municipality)
				@province = FormatRailsJavascriptVariable(province)
				@postalCode = FormatRailsJavascriptVariable(postalCode)
				@offenceNo = FormatRailsJavascriptVariable(offenceNo)
				@givenName = FormatRailsJavascriptVariable(firstName)
				@familyName = FormatRailsJavascriptVariable(lastName)
				@emailAddress = FormatRailsJavascriptVariable(emailAddress)

				telephoneNoArray = FormatRailsJavascriptVariable(telephoneNo).split("-")
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

				@languageToInterpretTo = FormatRailsJavascriptVariable(languageToInterpretTo)

				if offenceDate.nil?
					@offenceDate = ""
				else
					@offenceDate = offenceDate.strftime("%Y-%m-%d")
				end

				@iconCodesArray = GetAllICONCodes()
				if iconCode.nil?
					@iconCode = ""
				else
					@iconCode = iconCode
				end
				
				if trialLanguage.nil? || trialLanguage.empty? || trialLanguage == "EN"
					@isEnglish = true
				else
					@isEnglish = false
				end
			else
				render html: "The user could not be verified"
			end
		end
	end

	def SavePOAInformation
		currentUser = GetUserBySenderId(params[:id])
		if currentUser.present?
			userId = currentUser.first[:id]
			currentTicket = GetCurrentTicket(userId).first
			ticketId = currentTicket[:id]

			givenName = params[:givenName]
			familyName = params[:familyName]
			telephoneNo = params[:telephoneNo]
			emailAddress = params[:emailAddress]
			streetNo = params[:streetNo]
			street = params[:street]
			apt = params[:apt]
			municipality = params[:municipality]
			province = params[:province]
			postalCode = params[:postalCode]
			offenceNo = params[:offenceNo]
			offenceDate = params[:offenceDate]
			iconCode = params[:iconCode]
			languageToInterpretTo = params[:languageToInterpretTo]
			isEnglish = params[:isEnglish]

			isEnglishTrial = true			
			if isEnglish != "true"
				isEnglishTrial = false
			end

			SetDefendantMailingAddressByUserId(ticketId, streetNo, street, apt, municipality, province, postalCode)
			SetTicketOffenceNumber(ticketId, offenceNo)
			SetTicketICONCode(ticketId, iconCode)
			SetTicketOffenceDate(ticketId, offenceDate)
			SetTicketGivenName(ticketId, givenName)
			SetTicketFamilyName(ticketId, familyName)
			SetTicketTelephoneNumber(ticketId, telephoneNo)
			SetTicketEmailAddress(ticketId, emailAddress)
			SetTrialLanguageByTicketId(ticketId, isEnglishTrial)
			SetLanguageToInterpretToByTicketId(ticketId, languageToInterpretTo)
		end
	end

	def SendFormattedPOAFormToChat
		require 'pdf_forms'
		require 'date'

		senderId = params[:id][0] #NOTE: unsure why this is being received as an array instead of a string
		
		currentUser = GetUserBySenderId(senderId)
		if currentUser.present?
			givenName = params[:givenName]
			familyName = params[:familyName]
			telephoneNo = params[:telephoneNo]
			telephoneNo1 = params[:telephoneNo1]
			telephoneNo2 = params[:telephoneNo2]
			telephoneNo3 = params[:telephoneNo3]
			emailAddress = params[:emailAddress]
			streetNo = params[:streetNo]
			street = params[:street]
			apt = params[:apt]
			municipality = params[:municipality]
			province = params[:province]
			postalCode = params[:postalCode]
			offenceNo = params[:offenceNo]
			offenceDate = params[:offenceDate]
			iconCode = params[:iconCode]
			languageToInterpretTo = params[:languageToInterpretTo]
			isEnglish = params[:isEnglish]
			isLanguageInterpreterRequired = params[:isLanguageInterpreterRequired]
			isMobile = params[:isMobile]

			isFrench = ''
			frenchLanguageToInterpretTo = ''

			if isEnglish == 'true'
				isEnglish = 'X'
				isFrench = ''
			else 
				isFrench = 'X'
				isEnglish = ''
				if isLanguageInterpreterRequired == 'true'
					frenchLanguageToInterpretTo = languageToInterpretTo
					languageToInterpretTo = ''
				end
			end

			if !givenName.nil? && !givenName.empty? && !familyName.nil? && !familyName.empty?
				initials = givenName[0] + familyName[0]
			else
				initials = ""
			end

			currentDate = ''
			if params[:isCurrentDateChecked] == "true"
				currentDate = Time.now.strftime("%m/%d/%Y")
			end

			basePOAFolderPath =  "#{ENV["BASE_POA_FOLDER_PATH"]}"
			templatePDFFilePath = "#{basePOAFolderPath}/NoticeOfAttentionToAppearForm.pdf"
			signaturePNGFilePath = "#{basePOAFolderPath}/signature_#{senderId}.png"
			pdfFilePath = "#{basePOAFolderPath}/NoticeOfIntentionToAppearForm_#{senderId}.pdf"
			tmpFilePath = "#{basePOAFolderPath}/NoticeOfIntentionToAppearForm_#{senderId}_0.pdf"
			
			#Delete files if they already exist
			filePathArray = [signaturePNGFilePath, pdfFilePath, tmpFilePath]
			DeleteFiles(filePathArray)
			
			#Create Signature
			data_url = params[:signatureImage]
			png = Base64.decode64(data_url['data:image/png;base64,'.length .. -1])
			File.open(signaturePNGFilePath, 'wb') { |f| f.write(png) }
			pdftkFilePath = ENV['PDFTK_PATH']
			#Create Temporary PDF that has all text fields, but no signature
			pdftk = PdfForms.new(pdftkFilePath)
			pdftk.fill_form templatePDFFilePath, tmpFilePath, {:givenName => givenName, :familyName => familyName, :initials => initials,
				:streetNo => streetNo, :street => street, :apt => apt, :municipality => municipality, :province => province, 
				:postalCode => postalCode, :offenceNo => offenceNo, :offenceDate => offenceDate, :iconCode => iconCode,
				:languageToInterpretTo => languageToInterpretTo, :frenchLanguageToInterpretTo => frenchLanguageToInterpretTo,
				:isEnglish => isEnglish, :isFrench => isFrench, :currentDate => currentDate,
				:telephoneNo1 => telephoneNo1, :telephoneNo2 => telephoneNo2, :telephoneNo3 => telephoneNo3, :emailAddress => emailAddress},
				:flatten => true
			
			PlaceSignatureInPOAForm(senderId, isMobile, signaturePNGFilePath, tmpFilePath, pdfFilePath)
			
			filePathArray = [tmpFilePath]
			DeleteFiles(filePathArray)
			SendPDFToUser(senderId)
		end
		
	end

	def PlaceSignatureInPOAForm(senderId, isMobile, signaturePNGFilePath, tmpFilePath, pdfFilePath)
		require 'base64'

		#TODO: Make sure there are no issues with using outdated Prawn version 0.12.0
		Prawn::Document.generate(pdfFilePath, :template => tmpFilePath) do
			if isMobile == "true"
				image signaturePNGFilePath, :at => [350, 1000], :scale => 0.75
			else
				image signaturePNGFilePath, :at => [350, 1000], :scale => 0.87
			end
			
		end

  		filePathArray = [signaturePNGFilePath]
		DeleteFiles(filePathArray)
	end

	def DeleteFiles(filePathArray)
		filePathArray.each do |filePath|
			if File.exist?(filePath)
				File.delete(filePath)
	   		end
		end
	end

	def SendPDFToUser(senderId)
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
		        "url" => "https://#{ENV["PRODUCTION_BASE_URL"]}/NoticeOfIntentionToAppearForm?auth=#{senderId}"
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

    	if response.message == "OK"
			render :html => "OK"
		else
			render :html => "ERROR"
		end
	end

	def NoticeOfIntentionToAppearForm
		senderId = params[:auth]
		basePOAFolderPath =  "#{ENV["BASE_POA_FOLDER_PATH"]}"
		pdfFilePath = "#{basePOAFolderPath}/NoticeOfIntentionToAppearForm_#{senderId}.pdf"
		fileNameToDisplay = "Notice of Intention to Appear Form.pdf"
		if File.exist?(pdfFilePath)
			File.open(pdfFilePath, 'r') do |f|
				send_data f.read, :type => "application/pdf"
			end
		else
			puts "File does not exist"
   		end
		#filePathArray = [pdfFilePath]
		#DeleteFiles(filePathArray)
	end

	def FormatRailsJavascriptVariable(variableValue)
		if variableValue.nil? || variableValue.empty?
			variableValue = ""
		end
		return variableValue
	end

	def DeleteNOIForm
		id = params['messenger user id']
		currentUser = GetUserBySenderId(id)
		if currentUser.present?
			basePOAFolderPath =  "#{ENV["BASE_POA_FOLDER_PATH"]}"
			pdfFilePath = "#{basePOAFolderPath}/NoticeOfIntentionToAppearForm_#{id}.pdf"
			if File.exist?(pdfFilePath)
				File.delete(pdfFilePath)
	   		end
		end	
	end

	def EmailTest
		respond_to do |format|
			PdfMailer.email_poa_form("X").deliver_now
			format.html {redirect_to('', notice: 'Email attempt made.') }
			format.json { render json: 'Email attempt made.', status: :created, location: 'Email attempt made.' }
		end
	end
	
end
