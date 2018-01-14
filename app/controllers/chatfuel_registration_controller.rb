class ChatfuelRegistrationController < ApplicationController
	
	def RegisterChatfuelUser		
		render html: "RegisterChatfuelUser"
		id = params['messenger user id']
		if !UserFBIdExists(id)
			user = User.new(FacebookId: id, SenderId: id)
			user.save
		end
	end

end
