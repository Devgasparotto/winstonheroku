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
		puts "Does it exist: " + File.exist?(disclosureLetterPath)
		if File.exist?(disclosureLetterPath)
			puts "Attempting to delete"
			File.delete(disclosureLetterPath)
			puts "deleted file"
		end

		pdftk.fill_form templateDisclosureLetterPath, disclosureLetterPath, {
			:courtAddressLine1 => "courtAddressLine1", :courtAddressLine2 => "courtAddressLine2"},
			:flatten => true

		puts "Created " + File.exist?(disclosureLetterPath)
		render html: "HI"
	end

end
