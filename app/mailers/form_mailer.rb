class FormMailer < ApplicationMailer
	default from: 'tsbotmanager@gmail.com'

	def sample_pdf_email(pdfFilePath)
		attachments['test.pdf'] = File.read(pdfFilePath)
		mail(to: 'tsbotmanager@gmail.com', subject: "Test Email #{pdfFilePath}")
	end
end
