TOOL.Category		= "Freeway"
TOOL.Name			= "#tool.freeway_keycard_config.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if CLIENT then
	surface.CreateFont("sxlis_Font", {font = "Roboto Cn", size = 20, weight = 600, shadow = false})

	for k, v in pairs(freeway.keycard.levels) do 
		CreateConVar("freeway_keycard_tool_" .. k, "0", {}, "This is a client-side convar.")
	end

	language.Add("tool.freeway_keycard_config.name", "FKeycard Configurator")
	language.Add("tool.freeway_keycard_tool.name", "FKeycard Configurator")
	language.Add("tool.freeway_keycard_tool.desc", "Configure the keycard access for the target Button.")

	function TOOL.BuildCPanel( cpanel )
		cpanel:AddControl( "Header", { Description = "#tool.freeway_keycard_tool.desc" } )
		for k, v in pairs(freeway.keycard.levels) do 
			cpanel:NumSlider( k .. " Level", "freeway_keycard_tool_" .. k, 0, v, 0)
		end
	end

	local color_red = Color( 255, 0, 0 )
	function TOOL:DrawHUD()
		local x, y = ScrW() / 2, ScrH() * 0.75
		local ent = LocalPlayer():GetUseEntity()

		if IsValid( ent ) then
			local text_info = nil
			local can_be_used = freeway.keycard.keycard_available_classes[ent:GetClass()]

			--  alert from FPP prohibition 
			if FPP and not FPP.canTouchEnt( ent, "Toolgun" ) then
				text_info = "Falco's Prop Protection prevent you from editing this entity, please ensure both 'Admins can use tool on world/blocked entities' are enabled in the 'Toolgun options'!"
			end

			--  alert from unused class
			if text_info == nil and not can_be_used then
				local concat = ""

				for class in pairs( freeway.keycard.keycard_available_classes ) do
					concat = concat .. ( "'%s'" ):format( class ) .. ( next( freeway.keycard.keycard_available_classes, class ) and ", " or "" )
				end

				if freeway.keycard.savedata == nil then
					net.Start( "freeway_keycard_data_request" )
					net.SendToServer()
					return
				end

				
				text_info = "The target entity class must be one of these: " .. concat
			end

			local ent_id = ent:MapCreationID()

			if istable(freeway.keycard.savedata[ent_id]) and istable(freeway.keycard.savedata[ent_id]) then
				local offset = 0
				for k, v in pairs( freeway.keycard.savedata[ent_id] ) do
					if v == 0 then continue end
					draw.SimpleText(  ( "%s: %s" ):format( k, v ), "sxlis_Font", x-50, y + offset + 50, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					offset = offset + 20
				end
			end

			--  draw entity
			draw.SimpleText( "Target: " .. tostring( ent ), "Trebuchet24", x, y, can_be_used and color_white or color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			--  draw additional info
			if text_info then
				draw.SimpleText( text_info, "sxlis_Font", x, y + 30, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		else
			draw.SimpleText( "Target: none", "Trebuchet24", x, y, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

end --[[ if (CLIENT) then ]]--

--  add access
function TOOL:LeftClick( tr )
	local ply = self:GetOwner()
	if ply.freeway_keycard_tool_last_use == nil then ply.freeway_keycard_tool_last_use = 0 end
	if ply.freeway_keycard_tool_last_use > CurTime() then return false end
	ply.freeway_keycard_tool_last_use = CurTime() + 0.1

	--  check compatible entity
	local ent = tr.Entity
	if not IsValid( ent ) or not freeway.keycard.keycard_available_classes[ent:GetClass()] then return false end

	local data = {}
	data = {}
	for k, v in pairs( freeway.keycard.levels ) do
		data[k] = GetConVar("freeway_keycard_tool_" .. k):GetInt()
	end

	net.Start( "freeway_keycard_set_access" )
		net.WriteEntity( ent )
		net.WriteTable( data )
	net.SendToServer()
	
	return true
end

--  remove access
function TOOL:RightClick( tr )
	local ply = self:GetOwner()
	if ply.freeway_keycard_tool_last_use == nil then ply.freeway_keycard_tool_last_use = 0 end
	if ply.freeway_keycard_tool_last_use > CurTime() then return false end
	ply.freeway_keycard_tool_last_use = CurTime() + 0.1

	--  check compatible entity
	local ent = ply:GetUseEntity()
	if not IsValid( ent ) or not freeway.keycard.keycard_available_classes[ent:GetClass()] then return false end

	net.Start( "freeway_keycard_set_access" )
		net.WriteEntity( ent )
		net.WriteTable( {} )
	net.SendToServer()
	ply:ChatPrint( "The looked entity's data has been erased!" )

	return true
end

function TOOL:Reload( tr )
	local ply = self:GetOwner()
	if ply.freeway_keycard_tool_last_use == nil then ply.freeway_keycard_tool_last_use = 0 end
	if ply.freeway_keycard_tool_last_use > CurTime() then return false end
	ply.freeway_keycard_tool_last_use = CurTime() + 0.1

	--  check compatible entity
	local ent = ply:GetUseEntity()
	if not IsValid( ent ) or not freeway.keycard.keycard_available_classes[ent:GetClass()] then return false end

	if CLIENT then
		local ent_id = ent:MapCreationID()
		if freeway.keycard.savedata[ent_id] != nil and not table.IsEmpty(freeway.keycard.savedata[ent_id]) then
			for k, v in pairs( freeway.keycard.levels ) do
				GetConVar("freeway_keycard_tool_" .. k):SetInt( freeway.keycard.savedata[ent_id][k] || 0 )
			end
			ply:ChatPrint( "The looked entity's data was copied!" )
		else
			ply:ChatPrint( "The looked entity has no data!" )
		end
	end

	return true
end