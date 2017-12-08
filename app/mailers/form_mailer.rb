class FormMailer < ApplicationMailer
	default from: 'devgasp@gmail.com'

	def sample_pdf_email(pdfFilePath)
		attachments['test.pdf'] = File.read(pdfFilePath)
		mail(to: 'devgasp@gmail.com', subject: "Test Email #{pdfFilePath}")
	end
end
