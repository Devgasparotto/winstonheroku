class InputValidatorController < ApplicationController
	include InputValidatorHelper
	include JsonHelper

	def IsDateTimeInPast
		date = params[:date]
		time = params[:time]
		isValidDateAndTime = false

		dateTimeString = date + " " + time

		if IsDate(date) && IsTime(time) && !IsFuture(dateTimeString)
			isValidDateAndTime = true
		end
		json = CreateSingleAttributeJSON("isValidDateAndTime", "#{isValidDateAndTime}")

		render json: json
	end

	def IsDateTimeFormatCorrect
		date = params[:date]
		time = params[:time]
		isValidDateAndTime = false

		dateTimeString = date + " " + time

		if IsDate(date) && IsTime(time)
			isValidDateAndTime = true
		end
		json = CreateSingleAttributeJSON("isValidDateAndTime", "#{isValidDateAndTime}")

		render json: json
	end

	def IsDateInPast
		date = params[:date]
		isValidDateAndTime = false
		if IsDate(date) && !IsFuture(date)
			isValidDateAndTime = true
		end
		json = CreateSingleAttributeJSON("isValidDateAndTime", "#{isValidDateAndTime}")

		render json: json
	end

	def IsDateFormatCorrect
		date = params[:date]
		isValidDateAndTime = false

		if IsDate(date)
			isValidDateAndTime = true
		end
		json = CreateSingleAttributeJSON("isValidDateAndTime", "#{isValidDateAndTime}")

		render json: json
	end

end
