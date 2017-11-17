class WelcomeController < ApplicationController

	def testPDF
		pdftk = PdfForms.new('/vendor/pdftk/bin/pdftk')
		
	end

end
