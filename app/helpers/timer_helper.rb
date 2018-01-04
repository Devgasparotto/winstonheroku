module TimerHelper
	include UserUtilityHelper
	include TicketPropertiesHelper
	include TicketHelper
	

	def CreateTimer(userId, timerType, runAtDate)
		user = GetUserBySenderId(userId).first
		if user.present?
   			currentTicket = GetCurrentTicket(user[:id]).first
   			if currentTicket.present?
   				ticketId = currentTicket[:id]
				timerType = TimerType.find_by(TypeName: timerType)
				if !timerType.nil?
					timer = Timer.new(TimerTypeId: timerType[:id], TicketId: ticketId, RunAtDate: runAtDate, HasRun: 0)
					timer.save
				end
   			end
		end
	end

	def ExecuteTimerByTimerType(timerType)
		require 'net/http'
		require 'uri'

		timers = GetReadyTimersByTimerType(timerType)
		timers.each do |timer|
			if IsTicketCurrent(timer[:TicketId])
				senderId = GetSenderIdByTimer(timer)
				
				broadcastURL = CreateBroadcastURL(senderId, timerType)
				uri = URI.parse(broadcastURL)
				request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
				req_options = {
				  use_ssl: uri.scheme == "https",
				}

				response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
					begin
						http.request(request)
					rescue => e
						puts e
					end
				end

				if response.message == 'OK'
					timer.HasRun = 1
					timer.save
				end
			end
		end
	end

	def DeleteTrialByTimerType(userId, timerType)
		user = GetUserBySenderId(userId).first
		if user.present?
   			currentTicket = GetCurrentTicket(user[:id]).first
   			if currentTicket.present?
   				ticketId = currentTicket[:id]
   				timers = GetUnrunTimersByTimerTypeTicketId(timerType, ticketId)
   				timers.each do |timer|
					timer.update(HasRun: 2) #Indicates the timer has been deleted
				end
   			end
		end
	end

	def GetSenderIdByTimer(timer)
		user = GetUserByTicketId(timer[:TicketId])
		return user[:SenderId]
	end

	def CreateBroadcastURL(senderId, timerType)
		broadcastURL = ENV['CHATFUEL_BROADCAST_API']
		broadcastURL = broadcastURL.gsub('{CHATFUEL_BOT_ID}', ENV['CHATFUEL_BOT_ID'])
		broadcastURL = broadcastURL.gsub('{TOKEN}', ENV['CHATFUEL_TOKEN'])
		broadcastURL = broadcastURL.gsub('{SENDER_ID}', senderId)
		broadcastURL = broadcastURL.gsub('{BLOCK_NAME}', timerType)
		return broadcastURL
	end

	def GetReadyTimersByTimerType(timerType)
		timerTypeId = TimerType.where(TypeName: timerType)[0][:id]
		currentTime = Time.now
		return Timer.where(TimerTypeId: timerTypeId, HasRun: 0).where('RunAtDate < ?', DateTime.now)
	end

	def GetUnrunTimersByTimerTypeTicketId(timerType, ticketId)
		timerTypeId = TimerType.where(TypeName: timerType)[0][:id]
		return Timer.where(TimerTypeId: timerTypeId, TicketId: ticketId, HasRun: 0)
	end
end
