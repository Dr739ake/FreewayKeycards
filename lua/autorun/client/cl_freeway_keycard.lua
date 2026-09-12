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

net.Receive("freeway_keycard_data_init", function()
    print("Received keycard data")
    freeway.keycard.savedata = net.ReadTable()
end)

net.Receive("freeway_keycard_data_request", function()
    print("Received keycard data")
    freeway.keycard.savedata = net.ReadTable()
end)

surface.CreateFont("freeway_keycard_font", {font = "Roboto Cn", size = 20, weight = 600, shadow = false})

hook.Add("HUDPaint", "freeway_keycard_draw", function()
    local ent = LocalPlayer():GetEyeTrace().Entity
    if ent:IsValid() == false or ent:GetClass() == "worldspawn" or ent:GetPos():Distance(LocalPlayer():GetPos()) >= 100 then return end
    if freeway.keycard.keycard_available_classes[ent:GetClass()] then
        local color = Color( 255,255,255 )

        local ent_id = ent:MapCreationID()

        if freeway.keycard.savedata[ent_id] != nil and not table.IsEmpty(freeway.keycard.savedata[ent_id]) then
            for k, v in pairs( freeway.keycard.savedata[ent_id] ) do
                if LocalPlayer():GetActiveWeapon().Base == "freeway_keycard_base" then
                    local ply_access = LocalPlayer():GetActiveWeapon().Access
                    if check_access( ply_access, freeway.keycard.savedata[ent_id] ) then
                        color = Color( 0, 200, 0 )
                    else
                        color = Color( 200, 0, 0 )
                    end
                end

                local x, y = ScrW() / 2, ScrH() / 2 + 60 or ScrH() / 2 + 20

                draw.SimpleText(
                    freeway.keycard.keycard_required_text,
                    "freeway_keycard_font",
                    ScrW() / 2 + 1,
                    ScrH() / 2 + 61,
                    Color(0, 0, 0, 255),
                    TEXT_ALIGN_CENTER,
                    TEXT_ALIGN_CENTER
                )

                draw.SimpleText(
                    freeway.keycard.keycard_required_text,
                    "freeway_keycard_font",
                    ScrW() / 2,
                    ScrH() / 2 + 60,
                    color,
                    TEXT_ALIGN_CENTER,
                    TEXT_ALIGN_CENTER
                )
            end
        end
    end
end)