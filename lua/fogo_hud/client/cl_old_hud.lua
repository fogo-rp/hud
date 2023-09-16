local hideHUD = {
    ["CHudAmmo"] = true,
    ["CHudBattery"] = true,
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["DarkRP_HUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["DarkRP_ChatReceivers"] = true
}

hook.Add("HUDShouldDraw", "FogoHUD:HUDShouldDraw", function(name )
    if hideHUD[name] then
        return false
    end
end)