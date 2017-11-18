class WelcomeController < ApplicationController

	def testPDF
		fileExist = File.exist?("/app/vendor/pdftk/bin/pdftk")
		puts "/app/vendor/pdftk/bin/pdftk: #{fileExist}"

		pdftk = PdfForms.new('/app/vendor/pdftk/bin/pdftk')
	end

end
