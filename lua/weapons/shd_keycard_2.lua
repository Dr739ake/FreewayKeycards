AddCSLuaFile()

local name = "Sicherheitsdienst"
SWEP.Base = "freeway_keycard_base"

SWEP.PrintName 				= name .. " Keycard 2"
SWEP.Author					= "Jonas🍉"
SWEP.Purpose				= ""
SWEP.Category               = "Freeway Keycards"

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Access = {
    [name] = 2,
}

local SKIN = 10

SWEP.v_model = "models/freeway/keycards/keycard.mdl"
SWEP.w_model = "models/freeway/keycards/keycard.mdl"

SWEP.GuthSCPRenderer = {
    world_model = {
        model = SWEP.w_model,
        skin = SKIN,
        swep_ck = {
            enabled = true, 
            bone = "ValveBiped.Bip01_R_Hand",
            pos = Vector( 3.5, 3.5, -1.558 ), 
		    angle = Angle( 0, 180, 0 ), 
		    size = Vector( 0.755, 0.755, 0.755 ), 
        },
    },
    view_model = {
        model = SWEP.v_model,
        skin = SKIN,
        use_hands = true,
        swep_ck = {
            enabled = true,
            bone = "ValveBiped.Bip01_R_Finger0",
            pos = Vector( 5, -1, -0.519 ),
            angle = Angle( -90.183, -7.52, -99.351 ),
            size = Vector( 0.925, 0.925, 0.925 ),
        },
    },
}
