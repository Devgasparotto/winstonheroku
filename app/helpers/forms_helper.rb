module FormsHelper
	include UserUtilityHelper
	require 'date'

	def is_number? string
  	true if Float(string) rescue false
	end

	def disclosure_form(fb_id, epochTime)
		currentUser = GetUserByFacebookId(fb_id)
		currentTicket = GetCurrentTicket(currentUser.first[:id]).first
		ticketProperty = TicketProperty.find_by(TicketId: currentTicket[:id])
		#currentCourtDate = CourtDate.where(TicketId: currentTicket[:id]).first
		#TODO: Test this
		currentCourtDate = GetCourtDateByTicketId(currentTicket[:id])
		currentOfficer = Officer.where(TicketId: currentTicket[:id]).first
		
		# The date might need to change... Possibly
		date = Date.parse(Time.now.to_s).strftime("%B %d, %Y")
		lastname = currentTicket.TicketLastName
		firstname = currentTicket.TicketFirstName
		initial = currentTicket.TicketFirstName.first + currentTicket.TicketLastName.first
		charge = Charge.find_by(id: ticketProperty[:ChargeTypeId])
		offences = charge.Name
		#ticket_number = "1826733"
		ticket_number = currentTicket[:OffenceNumber]
		#offence_date = "January 1, 2017"
		offence_date = ticketProperty.OffenceDate
		#appearance_date = "January 1, 2017"
		#appearance_date = currentCourtDate.Date.strftime("%B %d, %Y")
		appearance_date = currentCourtDate.to_date.strftime("%B %d, %Y")
		#courtroom = "Courtroom 1"
		#courtroom = currentTicketAttributes.where(AttributeName: "CourtRoom")[0][:AttributeValue]
		courtroom = GetCourtRoomByTicketId(currentTicket[:id])
		#time = "3:30" # might make this 24 hour time
		#time = Time.parse(currentCourtDate)
		time = currentCourtDate.to_datetime.strftime("%I:%M")
		#date_and_time = '%m-%d-%Y %H:%M:%S %Z'
		#DateTime.strptime("04-15-2010 10:00:00 Central Time (US & Canada)",date_and_time)


		courtDateTime = time.to_time
		amOrPm = courtDateTime.strftime("%p")
		if(amOrPm == "AM")
			am = true
		else
			am = false
		end if
		#am = true # true is am, false is pm
		officer_name = currentOfficer[:Name]
		officer_number = currentOfficer[:Number]
		officer_division = currentOfficer[:Division]
		requested_by = ticketProperty.DisclosureRequestName
		telephone_number = "2892294738"


		# Get the layout file 
		file = File.read(Rails.root.to_s + "/docLayout/DisclosureForm.json")
		layout = JSON.parse(file)

		# open the baseline image for the disclosure form
		image = MiniMagick::Image.open(Rails.root.to_s + "/images/Toronto_Disclosure_Request.png")

		image.combine_options do |c|
			# c.gravity 'Center'
			c.pointsize '22'
			c.draw "text #{layout["date"]["x"]}, #{layout["date"]["y"]} '#{date}'"
			c.draw "text #{layout["lastname"]["x"]}, #{layout["lastname"]["y"]} '#{lastname}'"
			c.draw "text #{layout["firstname"]["x"]}, #{layout["firstname"]["y"]} '#{firstname}'"
			c.draw "text #{layout["initial"]["x"]}, #{layout["initial"]["y"]} '#{initial}'"
			c.draw "text #{layout["offences"]["x"]}, #{layout["offences"]["y"]} '#{offences}'"
			c.draw "text #{layout["ticket_number"]["x"]}, #{layout["ticket_number"]["y"]} '#{ticket_number}'"
			c.draw "text #{layout["offence_date"]["x"]}, #{layout["offence_date"]["y"]} '#{offence_date}'"
			c.draw "text #{layout["appearance_date"]["x"]}, #{layout["appearance_date"]["y"]} '#{appearance_date}'"
			c.draw "text #{layout["courtroom"]["x"]}, #{layout["courtroom"]["y"]} '#{courtroom}'"
			c.draw "text #{layout["time"]["x"]}, #{layout["time"]["y"]} '#{time}'"
			if(am)
				c.draw "text #{layout["am"]["x"]}, #{layout["am"]["y"]} 'X'"
			else
				c.draw "text #{layout["pm"]["x"]}, #{layout["pm"]["y"]} 'X'"
			end
			c.draw "text #{layout["officer_name"]["x"]}, #{layout["officer_name"]["y"]} '#{officer_name}'"
			c.draw "text #{layout["officer_number"]["x"]}, #{layout["officer_number"]["y"]} '#{officer_number}'"
			c.draw "text #{layout["officer_division"]["x"]}, #{layout["officer_division"]["y"]} '#{officer_division}'"
			c.draw "text #{layout["requested_by"]["x"]}, #{layout["requested_by"]["y"]} '#{requested_by}'"
			c.draw "text #{layout["telephone_number"]["x"]}, #{layout["telephone_number"]["y"]} '#{telephone_number}'"

			c.fill 'black'
		end
		image.write(Rails.root.to_s + "/documents/disclosureForm_#{fb_id}_#{epochTime}.jpg")
		puts "ok"
	end


	# POA_noiticeOfIntentionToAppear form helper
	def POA_form(fb_id)
		puts fb_id

		currentUser = GetUserByFacebookId(fb_id)
		currentTicket = GetCurrentTicket(currentUser.first[:id]).first
		ticketProperty = TicketProperty.find_by(:TicketId => currentTicket[:id])
		mailAddrId = ticketProperty[:DefendantMailingAddressId].to_i
		
		address = Address.find(mailAddrId)

		streetAddr = address.StreetAddress.split(" ")
		if (is_number?(streetAddr[1]))
			apt_num = streetAddr[0]
			house_num = streetAddr[1]
			start = 2
		else
			apt_num = ""
			house_num = streetAddr[0]
			start = 1
		end
		street_name = ""
		(start..streetAddr.length-1).each do |val|
			street_name = street_name + streetAddr[val] + " "
		end

		# Get User Data - Use TicketProperty
		noticeOfOffenceDate = ticketProperty[:OffenceDate]
		userName = ticketProperty[:DefendantName]
		offenceNumber = ticketProperty[:OffenceNumber]


		file = File.read(Rails.root.to_s + "/docLayout/POA-Form-8-Notice-of-Intention-ot-Appear.json")
		layout = JSON.parse(file)

		image = MiniMagick::Image.open(Rails.root.to_s + "/images/POA-Form-8-Notice-of-Intention-ot-Appear.png")

		image.combine_options do |c|
			# c.gravity 'Center'
			c.pointsize '22'
			c.draw "text #{layout["fullname"]["x"]},#{layout["fullname"]["y"]} '#{currentTicket.TicketFirstName} #{currentTicket.TicketLastName}'"
			c.draw "text #{layout["currentAddress"]["x"]},#{layout["currentAddress"]["y"]} '#{house_num}'"
			c.draw "text #{layout["street"]["x"]},#{layout["street"]["y"]} '#{street_name}'"
			c.draw "text #{layout["apt"]["x"]},#{layout["apt"]["y"]} '#{apt_num}'"
			c.draw "text #{layout["municipality"]["x"]},#{layout["municipality"]["y"]} '#{address.City}'"
			c.draw "text #{layout["province"]["x"]},#{layout["province"]["y"]} '#{address.Province}'"
			c.draw "text #{layout["postalCode"]["x"]},#{layout["postalCode"]["y"]} '#{address.PostalCode}'"
			c.draw "text #{layout["offenceNumber"]["x"]},#{layout["offenceNumber"]["y"]} '#{offenceNumber}'"
			c.draw "text #{layout["offenceDate"]["x"]},#{layout["offenceDate"]["y"]} '#{noticeOfOffenceDate}'"

			# Add condition to check if the user has french as preference, 
			c.draw "text #{layout["intentCheck"]["x"]},#{layout["intentCheck"]["y"]} 'X'"
			# Add condition to check if user requested a language interpreter
			
			c.fill 'black'
			# c.draw "text 100,100 'Ruby'"
			# c.fill 'gray'
		end
		image.write(Rails.root.to_s + "/documents/noticeOfIntentionForm_#{fb_id}.jpg")
		puts "ok"
	end


end
