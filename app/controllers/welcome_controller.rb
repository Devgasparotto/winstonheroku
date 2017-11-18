class WelcomeController < ApplicationController

	def testPDF
		require 'pdf_forms'

		fileExist = File.exist?("/app/documents/DisclosureRequestLetter.pdf")
		puts "/app/documents/DisclosureRequestLetter.pdf: #{fileExist}"
		#puts File.stat("/app/bin/pdftk/bin/pdftk").mode.to_s(8)[3..5]
		pdftk = PdfForms.new('pdftk')
		pdftk.get_field_names '/app/documents/DisclosureRequestLetter.pdf'
		#pdftk = PdfForms.new('pdftk')
		render html: "HI"
	end

end
