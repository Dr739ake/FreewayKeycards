freeway = freeway or {}
freeway.keycard = freeway.keycard or {}
freeway.keycard.levels = freeway.keycard.levels or {}

local function check_access(ply_access, ent_required)
	if ply_access.Admin then return true end
	local access_granted = false
	for k, v in pairs(ply_access) do
		if ent_required[k] then
			if ent_required[k] <= v and ent_required[k] != 0 then
				access_granted = true
			end
		end
	end
	return access_granted
end

local function compress_table()
		local t = {}

	for ent_id, v in pairs(freeway.keycard.savedata) do
		local data = {}
		if v == nil then
			print("No level data for " .. ent_id)
			continue
		end
		for key, value in pairs(v) do
			if value != 0 then
				data[key] = value
			end
		end
		t[ent_id] = data
	end
	return t
end

util.AddNetworkString("freeway_keycard_data_init")
util.AddNetworkString("freeway_keycard_data_request")
util.AddNetworkString("freeway_keycard_set_access")

net.Receive("freeway_keycard_data_request", function(len, ply)
	if ply:IsAdmin() == false then return end
	print("Sending keycard data to " .. ply:Nick())
	timer.simpled(1, function()
		if not IsValid(ply) then return end
		net.Start("freeway_keycard_data_request")
			net.WriteTable( compress_table() )
		net.Send(ply)
	end)
end)

net.Receive("freeway_keycard_set_access", function(len, ply)
	if not IsValid(ply) or not ply:IsSuperAdmin() then return end
	local ent = net.ReadEntity()
	local data = net.ReadTable()

	if not IsValid( ent ) or not freeway.keycard.keycard_available_classes[ent:GetClass()] then return end

	print("Setting keycard data for " .. ent:GetClass() .. " " .. ent:MapCreationID())
	freeway.keycard.save_ent(ent, data)
end)

function freeway.keycard.save_ent(ent, data)
	local checksum = 0

	if data.level != nil then
		for k, v in pairs(data.level) do
			checksum = checksum + v
		end
	end

	if checksum == 0 and data.admin == false then
		ent.keycard_data = nil
		freeway.keycard.savedata[ent:MapCreationID()] = nil
		print("Keycard data erased")
	else
		ent.keycard_data = data
		freeway.keycard.savedata[ent:MapCreationID()] = data
	end

	net.Start("freeway_keycard_data_request")
		net.WriteTable( compress_table() )
	net.Broadcast()

	file.CreateDir( "freeway_keycard/" )
	local f = file.Open("freeway_keycard/" .. game.GetMap() .. ".json", "w", "DATA")
	f:Write(util.TableToJSON(compress_table(), true))
	f:Close()
end

function freeway.keycard.load_data()
	if not file.Exists("freeway_keycard/" .. game.GetMap() .. ".json", "DATA") then return end
	local f = file.Open("freeway_keycard/" .. game.GetMap() .. ".json", "r", "DATA")
	freeway.keycard.savedata = util.JSONToTable(f:Read())
	f:Close()

	for k, v in pairs(freeway.keycard.savedata) do
		local ent = ents.GetMapCreatedEntity(k)
		if IsValid(ent) and ent.keycard_data == nil then
			--print("Loading keycard data for " .. ent:GetClass() .. " " .. k)
			ent.keycard_data = v
		end
	end

	print("[FREEWAY] Keycard data loaded for " .. game.GetMap())
end

hook.Add("PlayerInitialSpawn", "freeway_keycard_load", function(ply)
	net.Start("freeway_keycard_data_init")
		net.WriteTable( compress_table() )
	net.Send(ply)
end)

hook.Add("PlayerUse", "freeway_keycard_use", function(ply, ent)
	if not IsValid(ent) or 
		not ent.keycard_data or
		table.IsEmpty(ent.keycard_data) then 
		return true 
	end

	local swep = ply:GetActiveWeapon()
	if swep.last_used != nil and swep.last_used + freeway.keycard.trigger_timeout > CurTime() then return false end
	
	local access_granted = false
	
	local ply_access = ply:GetActiveWeapon().Access
	if ply_access != nil then
		access_granted = check_access(ply_access, ent.keycard_data)
	end

	if swep.IsBiometric and access_granted then
		access_granted = swep.OriginalOwner == ply
	end
	
	if access_granted then
		-- print("Access granted")
		ent:EmitSound("buttons/button14.wav")
	else
		-- print("Access denied")
		ent:EmitSound("buttons/button18.wav")
	end
	swep.last_used = CurTime()
	
	return access_granted
end)

hook.Add("InitPostEntity", "freeway_keycard_load", freeway.keycard.load_data)
hook.Add("PostCleanupMap", "freeway_keycard_load", freeway.keycard.load_data)


print("[FREEWAY] Keycard system loaded")