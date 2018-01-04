module ChargeHelper
	def GetChargeByChargeIdName(chargeIdName)
		charge = Charges.find_by(ChargeIdName: chargeIdName)
		return charge
	end
end
