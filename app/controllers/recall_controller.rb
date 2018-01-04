class RecallController < ApplicationController
	include UserUtilityHelper
	include JsonHelper

	def SetRecallBlock
		render html: "test"
		currentUser = GetUserByFacebookId(params['chatfuel user id'])
		if currentUser.present?
			recallInstance = Recall.new(UserId: currentUser[0][:id], RecallBlock: params['last visited block name'])
			recallInstance.save
			puts params['last visited block name']
		end
	end

	def GetRecallBlockJSON
		currentUser = GetUserByFacebookId(params['chatfuel user id'])
		
		if currentUser.present?
			#Get Recall Block Name
			recallBlockName = GetLatestRecallBlockForUser(currentUser[0][:id])
			#Create Go Back message with Recall Button
			messageText = "Click What's Next to continue"
			buttonText = "What's Next"
			jsonGoBackMessage = CreateJSONWithSingleBlockButton(messageText, buttonText, recallBlockName)
			
			render json: jsonGoBackMessage
		end
	end

	def GetLatestRecallBlockForUser(userId)
		#Get Recall with highest Id from recallInstances
		recallInstances = Recall.where(UserId: userId).order("id DESC").first
		return recallInstances[:RecallBlock]
	end

end
