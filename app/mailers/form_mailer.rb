class FormMailer < ApplicationMailer
	default from: 'mailgun@sandbox2496379cc7f445659f2aba340feb5986.mailgun.org' #'devgasp@gmail.com'

	def sample_pdf_email(pdfFilePath)
		#attachments['test.pdf'] = File.read(pdfFilePath)
		mail(to: 'devgasp@gmail.com', subject: "Test Email #{pdfFilePath}")
	end
end
