class WelcomeController < ApplicationController

	def testPDF
		puts "/app/vendor/pdftk/bin/pdftk: " + File.exist?("/app/vendor/pdftk/bin/pdftk")
		puts "/vendor/pdftk/bin/pdftk: " + File.exist?("/vendor/pdftk/bin/pdftk")
		#pdftk = PdfForms.new('pdftk')

	end

end
