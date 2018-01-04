class PaymentController < ApplicationController
	include JsonHelper
	include CourthouseHelper

	#skip_before_filter :verify_authenticity_token, :only => [:update]
	after_action :cors_set_access_control_headers

	# For all responses in this controller, return the CORS access control headers.

	def cors_set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
		headers['Access-Control-Request-Method'] = '*'
		headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
	end
	
	def GeneratePaymentWebviewButton
		id = params['messenger user id']
		if !id.nil? && !id.empty?
			currentUser = GetUserBySenderId(id)
			if currentUser.present?
				subtitle = "In order to have Winston file your form, please follow the instructions on the form below."
				buttonText = "Enter code"
				url = "https://#{ENV['PRODUCTION_BASE_URL']}/noiPromoCodeEntry?id=#{params['messenger user id']}"
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

	def noi_promo_code_entry
		response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://www.messenger.com/"

		correctedURL = URI.unescape(request.original_url)
		uri    = URI.parse(correctedURL)
		params = CGI.parse(uri.query) #NOTE: this allows the "%3D" to be interpretered as "=" in the query string params when displaying the webpage

		if params['id'].nil? || params['id'].empty?
			render html: "The user could not be verified"
		else
			currentUser = GetUserBySenderId(params['id']).first
     		if currentUser.present?	
				@FB_APP_ID = ENV["FB_APP_ID"]
				@id = params['id']
			else
				render html: "The user could not be verified"
			end
		end
	end

	def ApplyPromoCode
		id = params[:id]
		if !id.nil? && !id.empty?
			currentUser = GetUserBySenderId(id)
			if currentUser.present?
				code = PromoCode.find_by(Code: params[:promoCode])
				if !code.nil? && (code.ExpiryDate.nil? || code.ExpiryDate >= Time.now)  && code.NumberOfUses < code.MaxNumberOfUses
					render html: "Success"
					response.body
					response.content_type
		        elsif !code.nil? && (code.NumberOfUses >= code.MaxNumberOfUses || code.ExpiryDate < Time.now)
		        	render html: "Used"
		        	response.body
					response.content_type
		        else
		        	render html: "Fail"
		        	response.body
					response.content_type
		        end
		    end
		end
	end

	def SubmitNOIDeliveryRequest
		id = params[:id]
		if !id.nil? && !id.empty?
			currentUser = GetUserBySenderId(id)
			if currentUser.present?
				code = PromoCode.find_by(Code: params[:promoCode])
				if !code.nil? && (code.ExpiryDate.nil? || code.ExpiryDate >= Time.now)  && code.NumberOfUses < code.MaxNumberOfUses && !params[:emailAddress].nil? && !params[:emailAddress].empty?
					response.body
					response.content_type
					currentTicket = GetCurrentTicket(currentUser.first[:id]).first
					nameHash = GetFBUserProperty(id)

					requesterEmailAddress = params[:emailAddress]
					EmailNOIForm(id, currentTicket.OffenceNumber, nameHash["first_name"], nameHash["last_name"], requesterEmailAddress, params[:promoCode])
					code.NumberOfUses += 1
					code.save
		        elsif !code.nil? && (code.NumberOfUses >= code.MaxNumberOfUses || code.ExpiryDate < Time.now)
		        	render html: "Used"
		        	response.body
					response.content_type
		        else
		        	render html: "Fail"
		        	response.body
					response.content_type
		        end
		    end
		end
	end

	def EmailNOIForm(keyId, ticketNo, firstName, lastName, requesterEmailAddress, promoCode)
		if ticketNo.nil? || ticketNo.empty?
			ticketNo = ""
		end
		if firstName.nil? || firstName.empty?
			firstName = ""
		end
		if lastName.nil? || lastName.empty?
			lastName = ""
		end
		keyId = keyId[0]
		subject = "Notice of Intention to Appear Form Delivery for " + firstName + " " + lastName
		html = "<html><p>Delivery required for Notice of Intention to Appear form</p>" +
		"<p>FB Name: " + firstName + " " + lastName + "</p>" +
		"<p>Requester Email: " + requesterEmailAddress + "</p>" +
		"<p>Ticket Number: " + ticketNo + "</p>" +
		"<p>Promo Code: " + promoCode + "</p>" +
		"<p>Id: " + keyId + "</p>" +
		"</html>"
		respond_to do |format|
			PdfMailer.email_poa_form(keyId, subject, html).deliver_now
			format.html {render html: "Success"}
		end
	end

	def FormatRailsJavascriptVariable(variableValue)
		if variableValue.nil? || variableValue.empty?
			variableValue = ""
		end
		return variableValue
	end


	def TestFBName
		result = RestClient.get("https://graph.facebook.com/v2.10/1438346182909347?fields=first_name,last_name,profile_pic,locale,timezone,gender&access_token=EAAY3ZBwcO6JQBAMq0ncUHZCvs8CiT6TezFYf9aXSJpyqhZBEY2OaTOsQMO0Ila87fxGRUZBWpZCV0m68WKQgKKS00AorF7toifzNIlUJwWY2WgpZB5AfyZCaHkul9A55kgfxmPbXEmwI3elLueUKgvhuZBwtmCWZBjqSotwEZBlKZB6RwZDZD", headers)
		result = JSON.parse(result)
		firstName = result["first_name"]
		lastName = result["last_name"]
		puts result
		render html: "test"
	end

	def GetFBUserProperty(id)
		senderId = id[0]
		#TODO: change url to an environment variable
		result = RestClient.get("https://graph.facebook.com/v2.10/#{senderId}?fields=first_name,last_name,profile_pic,locale,timezone,gender&access_token=#{ENV['FB_PAGE_ACCESS_TOKEN']}", headers)
		result = JSON.parse(result)
		firstName = result["first_name"]
		lastName = result["last_name"]
		nameHash = {
			'first_name' => firstName,
			'last_name' => lastName
		}
		return nameHash
	end
end
