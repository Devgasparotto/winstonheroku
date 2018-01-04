module InputValidatorHelper
	require 'date'

	def IsDate(date)
		begin
			dat = Date.parse(date)
		   	return true
		rescue ArgumentError
		   	return false
		end
	end

	def IsTime(time)
		begin
		   Time.parse(time)
		   return true
		rescue ArgumentError
		   return false
		end
	end

	def IsFuture(dateTimeString)
		if IsDate(dateTimeString)
			#DateTime.new(2013, 6, 29, 10, 15, 30).change(:offset => "-0500")
			Time.zone = "Eastern Time (US & Canada)"
			dateTime = Time.zone.parse(dateTimeString)
			return Time.now < dateTime
		end
		return false
	end

	def IsDateTimeWithinRange(startDate, endDate)

	end

	def IsDateTimeBeforeSecondDateTime(date, secondDate)

	end

	def IsDateTimeAfterSecondDateTime(date, secondDate)

	end

end
