class ChatfuelRegistrationController < ApplicationController
	
	def RegisterChatfuelUser		
		id = params['messenger user id']
		if !UserFBIdExists(id)
			user = User.new(FacebookId: id, SenderId: id)
			user.save
		end
		render html: "success"
	end

end
