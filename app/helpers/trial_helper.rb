module TrialHelper
	def SetTrialLanguageByTicketId(ticketId, isEnglish)
		trial = Trial.where(TicketId: ticketId).first
		if trial.present? && isEnglish
			trial.TrialLanguage = "EN"
			trial.save
		elsif trial.present?
			trial.TrialLanguage = "FR"
			trial.save
		end
	end

	def SetLanguageToInterpretToByTicketId(ticketId, languageToInterpretTo)
		trial = Trial.where(TicketId: ticketId).first
		if trial.present?
			trial.LanguageToInterpretTo = languageToInterpretTo
			trial.save
		end
	end

	def SetCourtDateByTicketId(ticketId, courtDate)
		trial = Trial.where(TicketId: ticketId).first
		if trial.present?
			trial.TrialDateTime = courtDate
			trial.save
		end
	end

	def GetLanguageToInterpretToByTicketId(ticketId)
		trial = Trial.where(TicketId: ticketId).first
		if trial.present?
			return trial[:LanguageToInterpretTo]
		end
	end

	def GetTrialLanguageByTicketId(ticketId)
		trial = Trial.where(TicketId: ticketId).first
		if trial.present?
			return trial[:TrialLanguage]
		end
	end

	def GetCourtDateByTicketId(ticketId)
		trial = Trial.where(TicketId: ticketId).first
		if trial.present?
			return trial[:TrialDateTime]
		end
	end

	def GetCourtRoomByTicketId(ticketId)
		trial = Trial.where(TicketId: ticketId).first
		if trial.present?
			return trial[:Courtroom]
		end
	end

	def SetCourtRoomByTicketId(ticketId, courtRoom)
		trial = Trial.where(TicketId: ticketId).first
		if trial.present?
			trial[:Courtroom] = courtRoom
			trial.save
		end
	end
end
