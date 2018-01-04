class ChatfuelRegistrationController < ApplicationController
	
	def RegisterChatfuelUser		
		render html: "RegisterChatfuelUser"

		if !UserFBIdExists(params['chatfuel user id'])
			parsedProfilePictureURL = helpers.ParseProfilePicURL(params['profile pic url'])
			user = User.new(FacebookId: params['chatfuel user id'], ProfilePicURL: parsedProfilePictureURL, SenderId: params['messenger user id'])
			user.save
		end
	end

end
