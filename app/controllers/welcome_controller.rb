class WelcomeController < ApplicationController

	def testPDF
		fileExist = File.exist?("/app/bin/pdftk/bin/pdftk")
		puts "/app/bin/pdftk/bin/pdftk: #{fileExist}"
		puts File.stat("/app/bin/pdftk/bin/pdftk").mode.to_s(8)[3..5]
		pdftk = PdfForms.new('/app/bin/pdftk/bin/pdftk')
		#pdftk = PdfForms.new('pdftk')
		render html: "HI"
	end

end
