freeway = freeway or {}
freeway.keycard = freeway.keycard or {}
freeway.keycard.levels = freeway.keycard.levels or {}
freeway.keycard.savedata = freeway.keycard.savedata or {}

freeway.keycard.levels["MTF"] = 4
freeway.keycard.levels["Sicherheitsdienst"] = 4
freeway.keycard.levels["Wissenschaftler"] = 4
freeway.keycard.levels["ContainmentUnit"] = 4
freeway.keycard.levels["Medic"] = 4
freeway.keycard.levels["Service"] = 2
freeway.keycard.levels["Techniker"] = 2
freeway.keycard.levels["Personal"] = 4
freeway.keycard.levels["Koch"] = 1
freeway.keycard.levels["Besucher"] = 1
freeway.keycard.levels["Management"] = 2
freeway.keycard.levels["Alpha"] = 1
freeway.keycard.levels["Omega"] = 1
freeway.keycard.levels["O5"] = 2
freeway.keycard.levels["Ethikkommision"] = 2
freeway.keycard.levels["ISD"] = 1
freeway.keycard.levels["HCZ"] = 1
freeway.keycard.levels["LCZ"] = 1
freeway.keycard.levels["EZ"] = 1
freeway.keycard.levels["DEA"] = 1

freeway.keycard.keycard_available_classes = {
	["func_button"] 		= true,
	["class C_BaseEntity"] 	= true,
	["class C_BaseToggle"] 	= true,
	["func_rot_button"] 	= true,
}

freeway.keycard.keycard_required_text = "Keycard benötigt"
freeway.keycard.trigger_timeout = 2.5
