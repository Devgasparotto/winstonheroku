class FormMailer < ApplicationMailer
	default from: 'devgasp@gmail.com'

	def test_email(pdfFilePath)
		mail(to: 'devgasp@gmail.com', subject: "Test Email #{pdfFilePath}")
	end
end
