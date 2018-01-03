class PdfController < ApplicationController
	include EmailHelper

	def CreateSamplePDF
		require 'pdf_forms'
		pdftkFilePath = ENV['PDFTK_PATH'] #'/app/bin/pdftk/bin/pdftk' #For Heroku Prod
		pdftk = PdfForms.new(pdftkFilePath)
		sampleTemplatePDFPath = '/app/documents/DisclosureRequestLetter.pdf'
		samplePDFPath = '/app/documents/test.pdf'
		puts File.exist?(samplePDFPath)
		if File.exist?(samplePDFPath)
			puts "Attempting to delete"
			File.delete(samplePDFPath)
			puts "deleted file"
		end

		pdftk.fill_form sampleTemplatePDFPath, samplePDFPath, {
			:courtAddressLine1 => "courtAddressLine1", :courtAddressLine2 => "courtAddressLine2"},
			:flatten => true

		render html: "test"
	end

	def CreateAndEmailSamplePDF
		require 'pdf_forms'
		pdftkFilePath = ENV['PDFTK_PATH'] #'/app/bin/pdftk/bin/pdftk' #For Heroku Prod
		pdftk = PdfForms.new(pdftkFilePath)
		sampleTemplatePDFPath = '/app/documents/DisclosureRequestLetter.pdf'
		samplePDFPath = '/app/documents/test.pdf'
		puts File.exist?(samplePDFPath)
		if File.exist?(samplePDFPath)
			puts "Attempting to delete"
			File.delete(samplePDFPath)
			puts "deleted file"
		end

		pdftk.fill_form sampleTemplatePDFPath, samplePDFPath, {
			:courtAddressLine1 => "courtAddressLine1", :courtAddressLine2 => "courtAddressLine2"},
			:flatten => true

		if File.exist?(samplePDFPath)
			puts "File created"
		end

		SamplePDFEmail(samplePDFPath)
	end
end
