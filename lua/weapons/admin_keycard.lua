AddCSLuaFile()

SWEP.Base = "freeway_keycard_base"

SWEP.PrintName 				= "Admin Keycard"
SWEP.Author					= "Jonas🍉"
SWEP.Purpose				= "Türen öffnen"
SWEP.Category               = "Freeway Keycards"

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.IsBiometric = true

SWEP.Access = {
    ["Admin"] = true,
}


local SKIN = 0

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

function SWEP:Reload()
    self.NextReload = self.NextReload or 0
    if CurTime() < self.NextReload then return end
    self.NextReload = CurTime() + 0.3
    local MAX_SKINS = 42
    local SKIN = self.GuthSCPRenderer.world_model.skin + 1
    if SKIN > MAX_SKINS then
        SKIN = 0
    end
    self.GuthSCPRenderer.world_model.skin = SKIN
    self.GuthSCPRenderer.view_model.skin = SKIN
    if CLIENT then
        surface.PlaySound("hl1/fvox/fuzz.wav")
    end
    self:run_init()
end