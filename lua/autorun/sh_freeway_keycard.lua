freeway = freeway or {}
freeway.keycard = freeway.keycard or {}
freeway.keycard.levels = freeway.keycard.levels or {}
freeway.keycard.savedata = freeway.keycard.savedata or {}

freeway.keycard.levels["Staff"] = 4
freeway.keycard.levels["Medic"] = 4
freeway.keycard.levels["Security"] = 4
freeway.keycard.levels["Sience"] = 4
freeway.keycard.levels["ContainmentUnit"] = 4
freeway.keycard.levels["MTF"] = 4
freeway.keycard.levels["HCZ"] = 1
freeway.keycard.levels["LCZ"] = 1
freeway.keycard.levels["EZ"] = 1
freeway.keycard.levels["Service"] = 2
freeway.keycard.levels["Management"] = 2
freeway.keycard.levels["Visitor"] = 1

freeway.keycard.keycard_available_classes = {
	["func_button"] 		= true,
	["class C_BaseEntity"] 	= true,
	["class C_BaseToggle"] 	= true,
	["func_rot_button"] 	= true,
	["12C_BaseToggle"] 		= true,
}

freeway.keycard.keycard_required_text = "Keycard required"
freeway.keycard.trigger_timeout = 2.5
