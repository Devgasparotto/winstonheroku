class WelcomeController < ApplicationController

	def testPDF
		require 'pdf_forms'
		#pdftkFilePath = '/app/bin/pdftk/bin' #For Heroku Prod
		pdftkFilePath = 'C:\Data\LegallyInc\B2Bot\BotFramework\bin\pdftk\bin'#'/bin/pdftk/bin/pdftk'
		puts File.exist?(pdftkFilePath)
		# FileUtils.chmod 0777, pdftkFilePath, :verbose => true
		# puts File.stat(pdftkFilePath).mode.to_s(8)
		pdftk = PdfForms.new(pdftkFilePath)
		# pdftk.get_field_names '/app/documents/DisclosureRequestLetter.pdf'
		#pdftk = PdfForms.new('pdftk')
		render html: "HI"
	end

end
