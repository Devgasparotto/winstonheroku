class WelcomeController < ApplicationController

	def testPDF
		fileExist = File.exist?("/app/vendor/pdftk/bin/pdftk")
		puts "/app/vendor/pdftk/bin/pdftk: #{fileExist}"
		puts File.stat("/app/vendor/pdftk/bin/pdftk").mode.to_s(8)[3..5]
		#pdftk = PdfForms.new('/app/vendor/pdftk/bin/pdftk')
	end

end
