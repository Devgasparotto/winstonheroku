module EmailHelper
	def SamplePDFEmail(pdfFilePath)
		respond_to do |format|
			puts "Attempting to email"
			FormMailer.sample_pdf_email(pdfFilePath).deliver_now
			puts "Emailed"
			format.html {render html: "Success"}
		end
	end
end
