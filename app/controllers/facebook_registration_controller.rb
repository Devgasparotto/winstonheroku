class FacebookRegistrationController < ApplicationController
	include UserUtilityHelper

	protect_from_forgery except: :AttemptToRegisterFacebookUser

	def RegisterFacebookUserAuthenticate
		if params[:'hub.verify_token'] == 'test_token' #move this to an environment variable
			logger.debug params[:'hub.challenge']
			render :text => params[:'hub.challenge']
		end
	end

	def AttemptToRegisterFacebookUser
		render html: "Hi there"
		#This code is no longer required because the senderId/Page Scoped User Id is obtainable by Chatfuel
		# senderId = params[:entry].first[:messaging].first[:sender][:id]
		# profilePicURL = GetProfilePicURLBySenderId(senderId)

		# usersWithSenderId = User.where(SenderId: senderId)

		# if usersWithSenderId.exists?
		# 	#TODO: verify there is no inconsistency when ProfilePicURL changes

		# 	latestUserWithProfilePicURL = User.where(ProfilePicURL: profilePicURL).order('id desc').limit(1) #Gets latest instance of user with profilePicURL
		# 	if latestUserWithProfilePicURL.exists? && latestUserWithProfilePicURL.first.SenderId != senderId
		# 		#Set the latest user with the ProfilePicURL to have senderId
				
		# 		#TODO: Ensure that by not setting SenderId's to null it does not allow sending of duplicate messages. We are no longer setting this to null so that 
		# 		# old messages that were required to be sent are still sent.
		# 		#usersWithSenderId.find_each do |user|
		# 		#	user.update(SenderId: nil)
		# 		#end
				
		# 		latestUserWithProfilePicURL.update(SenderId: senderId)
		# 	end
		
		# else
		# 	if !User.where(ProfilePicURL: profilePicURL).exists?
		# 		#add new user record with senderId and profilePicURL
		# 		newUserWithSenderIdProfilePicURL = User.new(SenderId: senderId, ProfilePicURL: profilePicURL)
		# 		newUserWithSenderIdProfilePicURL.save
		# 	else
		# 		#add senderId to this user record
		# 		#User.where(ProfilePicURL: profilePicURL).update_all(:SenderId => senderId)
		# 		latestUserWithProfilePicURL = User.where(ProfilePicURL: profilePicURL).order('id desc').limit(1) #Gets latest instance of user with profilePicURL
		# 		latestUserWithProfilePicURL.update(SenderId: senderId)
		# 	end
		# end
	end

	def GetProfilePicURLBySenderId(senderId)
		# TODO: put page token in config file
		headers = {"Content-Type" => "application/json"}
		result = RestClient.get("https://graph.facebook.com/v2.6/#{senderId}?fields=first_name,last_name,profile_pic,locale,timezone,gender&access_token=#{ENV['FB_PAGE_ACCESS_TOKEN']}", headers)
		result = JSON.parse(result)
		parsedProfilePicURL = helpers.ParseProfilePicURL(result["profile_pic"])
		return parsedProfilePicURL
	end


	def TestSendingMessage
		render html: "Hi there"
		#Get senderId
		senderId = helpers.GetSenderIdByFacebookId(params[:fb_id])
		helpers.SendMessage(senderId, "Hello there")
	end
end