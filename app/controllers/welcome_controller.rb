class WelcomeController < ApplicationController

	def testPDF
		fileExist = File.exist?("/app/vendor/pdftk/bin/pdftk")
		puts "/app/vendor/pdftk/bin/pdftk: #{fileExist}"

		fileExist = File.exist?("/vendor/pdftk/bin/pdftk")
		puts "/vendor/pdftk/bin/pdftk: #{fileExist}"
		
		#pdftk = PdfForms.new('pdftk')
	end

end
