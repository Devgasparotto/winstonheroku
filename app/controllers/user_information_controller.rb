class UserInformationController < ApplicationController
	def GenerateToken
		user = GetUserByFacebookId(params['chatfuel user id']).first
		
		if user.present?
			user.regenerate_auth_token
			user.has_been_preloaded_flag = false
			ttl = 5*60 #add 5 minutes to expiry time of token
			user.token_expiry_datetime = Time.now + ttl
			user.save
			
			attributes = {
				"tempToken": user.auth_token
			}
			
			messageArray = []

			setTokenAttributeJSON = {
				"set_attributes": attributes,
				"messages": messageArray
			}
			
			render json: setTokenAttributeJSON.to_json
		end
	end
end
