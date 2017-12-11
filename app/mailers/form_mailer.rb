class FormMailer < ApplicationMailer
	default from: ENV['MAILGUN_EMAIL_ADDRESS']

	def sample_pdf_email(pdfFilePath)
		attachments['test.pdf'] = File.read(pdfFilePath)
		mail(to: ENV['MAILGUN_EMAIL_ADDRESS'], subject: "Test Email #{pdfFilePath}")
	end
end
