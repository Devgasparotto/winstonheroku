class WelcomeController < ApplicationController

	def testPDF
		require 'pdf_forms'

		FileUtils.chmod 0777, '/app/bin/pdftk/bin', :verbose => true
		puts File.stat("/app/bin/pdftk/bin").mode.to_s(8)
		pdftk = PdfForms.new('/app/bin/pdftk/bin')
		# pdftk.get_field_names '/app/documents/DisclosureRequestLetter.pdf'
		#pdftk = PdfForms.new('pdftk')
		render html: "HI"
	end

end
