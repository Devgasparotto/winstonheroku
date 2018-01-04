class DisclosureFormController < ApplicationController
	def index
		#Get current timestamp and add to url so url isn't cached by receiving application
		epochTime = Time.new.strftime('%s%3N')

		helpers.disclosure_form(params[:fb_id], epochTime)
		# img = MiniMagick::Image.read(Rails.root.to_s + "/documents/text_shadow.jpg")
		#file_path = Rails.root.to_s + "/documents/text_shadow.jpg"
		#img = File.open(file_path, 'rb') { |file| file.read }

		#send_data img, type: "application/octet-stream", disposition: "inline"
		render :json => {:messages => 
			[:attachment => 
				{:type => "image", 
				:payload => 
						{:url => "https://takechargeticket.com/disclosureForm?auth=#{params[:fb_id]}&version=#{epochTime}"}
						# {:url => "http://64.137.252.83:9000/disclosureForm?auth=#{params[:fb_id]}"}
				}
			]
		}.to_json
	end

	def GetRenderedDisclosureForm
		formPath = "documents/disclosureForm_#{params[:auth]}_#{params[:version]}.jpg"
		#send_file formPath, type: 'image/jpeg', disposition: 'inline'
		#Delete file
		File.open(formPath, 'r') do |f|
			send_data f.read, type: 'image/jpeg'
		end
		File.delete(formPath)
	end
end
