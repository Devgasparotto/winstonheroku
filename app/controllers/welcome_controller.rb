class WelcomeController < ApplicationController

	def testPDF
		require 'pdf_forms'
		pdftkFilePath = '/app/bin/pdftk/bin/pdftk' #For Heroku Prod
		#pdftkFilePath = #'/bin/pdftk/bin/pdftk'
		#puts File.exist?(pdftkFilePath)
		# FileUtils.chmod 0777, pdftkFilePath, :verbose => true
		# puts File.stat(pdftkFilePath).mode.to_s(8)
		pdftk = PdfForms.new(pdftkFilePath)
		#puts pdftk.get_field_names '/app/documents/DisclosureRequestLetter.pdf'
		templateDisclosureLetterPath = '/app/documents/DisclosureRequestLetter.pdf'
		disclosureLetterPath = '/app/documents/test.pdf'
		puts File.exist?(disclosureLetterPath)
		if File.exist?(disclosureLetterPath)
			puts "Attempting to delete"
			File.delete(disclosureLetterPath)
			puts "deleted file"
		end

		pdftk.fill_form templateDisclosureLetterPath, disclosureLetterPath, {
			:courtAddressLine1 => "courtAddressLine1", :courtAddressLine2 => "courtAddressLine2"},
			:flatten => true

		puts File.exist?(disclosureLetterPath)
		render html: "HI"
	end

	def testRoute
		respond_to do |format|
			FormMailer.test_email("testPath").deliver_now
			format.html {render html: "Success"}
		end
	end

	def testEmail
		require 'rest-client'

		apikey = 'key-8ff2b34368c52e42b2e202035ddc7e6c'
		#API_KEY = ENV['MAILGUN_API_KEY']
		apiurl = "https://api:#{apikey}@api.mailgun.net/v2/sandbox2496379cc7f445659f2aba340feb5986.mailgun.org"
 
		RestClient.post apiurl+"/messages",
		    :from => "devgasp@gmail.com",
		    :to => "devgasp@gmail.com",
		    :subject => "This is subject",
		    :text => "Text body",
		    :html => "<b>HTML</b> version of the body!"
	end

	# def FormatPDFEmail(pdfFilePath)
	# 	subject = "PDF Email Delivery"
	# 	html = "<html><p>PDF Form Delivery</p>" +
	# 	"<p>File Path: " + pdfFilePath + "</p>" +
	# 	"</html>"
	# 	# respond_to do |format|
	# 	# 	EmailPDF(pdfFilePath).deliver_now
	# 	# 	format.html {render html: "Success"}
	# 	# end
	# 	EmailPDF(pdfFilePath, subject, html)
	# end

	# def EmailPDF(pdfFilePath, subject, html)
 #    	pdfFile = File.open(pdfFilePath, "r")
    
 #    	mg_client = Mailgun::Client.new 'key-8ff2b34368c52e42b2e202035ddc7e6c'
 #    	message_params = {:from    => 'devgasp@gmail.com',
 #                      :to      => 'devgasp@gmail.com',
 #                      :subject => subject,
 #                      :text    => "File sent.",
 #                      :html    => html,
 #                      :attachment => pdfFile}
 #    	mg_client.send_message 'sandbox2496379cc7f445659f2aba340feb5986.mailgun.org', message_params
      
 #    	if File.exist?(pdfFilePath)
 #    		#File.delete(pdfFilePath)
 #    	end
	# end

end
