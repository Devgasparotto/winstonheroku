class FormMailer < ApplicationMailer
	default from: 'devgasp@gmail.com'

	def test_email(pdfFilePath)
		attachments['test.pdf'] = File.read(pdfFilePath)
		mail(to: 'devgasp@gmail.com', subject: "Test Email #{pdfFilePath}")
	end
end
