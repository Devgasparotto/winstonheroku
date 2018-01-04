module CourthouseHelper
	def GetAllICONCodes
		iconCodes = []
		Courthouse.find_each do |courthouse|
			if !courthouse[:ICON].nil? && !iconCodes.include?(courthouse[:ICON])
				iconCodes.push(courthouse[:ICON])
			end
		end
		return iconCodes.sort
	end

	def GetAllChargeCodes
		chargeCodes = []
		Charge.find_each do |charge|
			if !charge[:ChargeIdName].nil? && !chargeCodes.include?(charge[:ChargeIdName])
				chargeCodes.push(charge[:ChargeIdName])
			end
		end
		return chargeCodes.sort
	end
end
