class WelcomeController < ApplicationController

	def testPDF
		pdftk = PdfForms.new('pdftk')

	end

end
