module EmailHelper
	def SamplePDFEmail(pdfFilePath)
		respond_to do |format|
			FormMailer.sample_pdf_email(pdfFilePath).deliver_now
			format.html {render html: "Success"}
		end
	end
end
