local function RespW(x)
    return x/1920*ScrW()
end

local function RespH(y)
    return y/1080*ScrH()
end

local elemPos = {
    ["base"] = {
        x = 5,
        y = 5,
        w = 368,
        h = 132,
    },
    ["base_2"] = {
        x = 0,
        y = 0,
        w = 436,
        h = 114,
    },
    ["base_22"] = {
        x = 0,
        y = 0,
        w = 442,
        h = 150,
    },
    ["health"] = {
        parent = "base_2",
        color = FogoHUD.GetColor("white"),
        x = 22,
        y = 24,
        w = 392,
        h = 30,
        armorPos = {
            x = 24,
            y = 25,
        }
    },
    ["mana"] = {
        parent = "base_2",
        x = 22,
        y = 60,
        w = 392,
        h = 30,
    },
    ["armor"] = {
        parent = "base_22",
        x = 24,
        y = 60,
        w = 392,
        h = 30,
    },
    ["health_text"] = {
        parent = "base_2",
        color = FogoHUD.GetColor("white"),
        aling = TEXT_ALIGN_CENTER,
        text = true,
        x = 218,
        y = 41,
        w = 392,
        h = 30,
        armorPos = {
            x = 218,
            y = 41,
        }
    },
    ["mana_text"] = {
        parent = "base_2",
        color = FogoHUD.GetColor("white"),
        aling = TEXT_ALIGN_CENTER,
        text = true,
        x = 218,
        y = 77,
        w = 392,
        h = 30,
    },
    ["armor_text"] = {
        parent = "base_22",
        color = FogoHUD.GetColor("white"),
        aling = TEXT_ALIGN_CENTER,
        text = true,
        armor = true,
        x = 218,
        y = 77,
        w = 392,
        h = 30,
    },
    ["model"] = {
        parent = "base",
        x = 21 + 5,
        y = 21 + 5,
        w = 90 - 10,
        h = 90 - 10,
    },
    ["name"] = {
        parent = "base",
        text = true,
        x = 122,
        y = 27,
        w = 230,
        h = 26,
    },
    ["job"] = {
        parent = "base",
        text = true,
        x = 122,
        y = 59,
        w = 230,
        h = 26,
    },
    ["money"] = {
        parent = "base",
        text = true,
        x = 122,
        y = 91,
        w = 230,
        h = 26,
    },
}

local multiInfo = 1.1
local multiBar = 1

// Base 1
elemPos["base"].w = RespW(elemPos["base"].w * multiInfo)
elemPos["base"].h = RespH(elemPos["base"].h * multiInfo)
elemPos["base"].x = RespW(elemPos["base"].x)
elemPos["base"].y = ScrH() - elemPos["base"].h - RespH(elemPos["base"].y)

// Base 2
elemPos["base_2"].w = RespW(elemPos["base_2"].w * multiBar)
elemPos["base_2"].h = RespH(elemPos["base_2"].h * multiBar)
elemPos["base_2"].x = ScrW() / 2 - elemPos["base_2"].w / 2
elemPos["base_2"].y = ScrH() - elemPos["base_2"].h

// Base 22
elemPos["base_22"].w = RespW(elemPos["base_22"].w * multiBar)
elemPos["base_22"].h = RespH(elemPos["base_22"].h * multiBar)
elemPos["base_22"].x = ScrW() / 2 - elemPos["base_22"].w / 2
elemPos["base_22"].y = ScrH() - elemPos["base_22"].h

// for every element in elemPos table, multiply by multi
for k, v in pairs(elemPos) do
    local multi = (elemPos[k].parent == "base") && multiInfo || multiBar
    
    if (k == "base" || k == "base_2" || k == "base_22") then continue end

    elemPos[k].w = RespW(elemPos[k].w * multi)
    elemPos[k].h = RespH(elemPos[k].h * multi)

    elemPos[k].x = elemPos[elemPos[k].parent].x + RespW(elemPos[k].x * multi)
    elemPos[k].y = elemPos[elemPos[k].parent].y + RespH(elemPos[k].y * multi)

    if (elemPos[k].armorPos) then
        elemPos[k].armorPos.x = elemPos["base_22"].x + RespW(elemPos[k].armorPos.x * multi)
        elemPos[k].armorPos.y = elemPos["base_22"].y + RespH(elemPos[k].armorPos.y * multi)
    end
end

local function coolMoneyShow(amount)
    // space every 3 char with a space, finish with a 'Ryo', round value and, if + 999 999 999 999 replace with 'Unlimited'
    if (amount >= 999999999) then
        return "Stop Cheating"
    end

    local str = string.reverse(string.format("%d", amount))
    str = string.gsub(str, "(%d%d%d)", "%1 ")
    str = string.gsub(str, "^%s*(.-)%s*$", "%1")
    str = string.reverse(str)
    str = string.gsub(str, "^%s*(.-)%s*$", "%1")
    str = str .. " Ryo"

    return str
end

local function amountSeparator(amount)
    local str = string.reverse(string.format("%d", amount))
    str = string.gsub(str, "(%d%d%d)", "%1 ")
    str = string.gsub(str, "^%s*(.-)%s*$", "%1")
    str = string.reverse(str)
    str = string.gsub(str, "^%s*(.-)%s*$", "%1")

    return str
end

local maxStr = math.Round(RespH(20))
local function shortInfo(str)
    if (string.len(str) > maxStr) then
        return string.sub(str, 1, maxStr) .. "..."
    end

    return str
end

local funcElement = {
    ["name"] = function(ply)
        return "Nom: " .. shortInfo(ply:Nick())
    end,
    ["job"] = function(ply)
        return "Metier: " .. shortInfo(ply:getDarkRPVar("job") || "Unknow")
    end,
    ["money"] = function(ply)
        return "Argent: " .. coolMoneyShow(ply:getDarkRPVar("money") || 0)
    end,
    ["health_text"] = function(ply)
        if (ply:HasGodMode()) then
            return "Invincible"
        end
        return amountSeparator(ply:Health()) .. " Vie"
    end,
    ["mana_text"] = function(ply)
        return amountSeparator(ply:GetNWInt("linv_mana") || 1000) .. " Chakra - en dev"
    end,
    ["armor_text"] = function(ply)
        return ply:Armor() .. " Armure"
    end,
}

local HeadModel = false

timer.Simple(0, function()
    HeadModel = vgui.Create("DModelPanel")
    HeadModel:SetSize(elemPos["model"].w, elemPos["model"].h)
    HeadModel:SetPos(0, 0)
    HeadModel:SetModel("models/player/kleiner.mdl")

    function HeadModel:LayoutEntity(Entity)
        self:SetLookAt(Entity:GetBonePosition(Entity:LookupBone("ValveBiped.Bip01_Head1")))
        self:SetCamPos(Entity:GetBonePosition(Entity:LookupBone("ValveBiped.Bip01_Head1")) + Vector(20, 0, 0))
    end
end)

local lerp_health, lerp_armor, lerp_mana = 0, 0, 0
local lerp_health_speed, lerp_armor_speed, lerp_mana_speed = 0.1, 0.1, 0.1

// create roboto font 16
surface.CreateFont("FogoFont:Roboto:18", {
    font = "Roboto",
    size = RespW(18),
    weight = 500,
    antialias = true,
    shadow = false,
})

hook.Add("HUDPaint", "FogoHUD:Paint", function()
    local ply = LocalPlayer()
    if !IsValid(ply) || !ply:Alive() || !HeadModel then
        return
    end

    // dev info
    draw.SimpleText("FOGO RP - " .. os.date("%Y-%m-%d") .. " " .. os.date("%H:%M:%S"), "FogoFont:Roboto:18", ScrW() - RespW(5), ScrH() - RespH(20), FogoHUD.GetColor("text"), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)

    local health_max = ply:GetMaxHealth()
    local health = math.Clamp(ply:Health(), 0, health_max)

    local armor_max = ply:GetMaxArmor()
    local armor = math.Clamp(ply:Armor(), 0, armor_max)

    local mana_max = ply:GetNWInt("linv_mana_max") || 1000
    local mana = math.Clamp(ply:GetNWInt("linv_mana") || 1000, 0, mana_max)

    local job = ply:getDarkRPVar("job") || "Unknow"
    local salary = ply:getDarkRPVar("salary") || 0
    local wallet = ply:getDarkRPVar("money") || 0


    // lerps
    lerp_health = Lerp(lerp_health_speed, lerp_health, health)
    lerp_armor = Lerp(lerp_armor_speed, lerp_armor, armor)
    lerp_mana = Lerp(lerp_mana_speed, lerp_mana, mana)

    // show hud base (image - FogoHUD.Materials("plyInfo.png"))
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.SetMaterial(FogoHUD.Materials["hud_base_2"])
    surface.DrawTexturedRect(elemPos["base"].x, elemPos["base"].y, elemPos["base"].w, elemPos["base"].h)

    -- Mettez à jour le modèle en fonction du joueur local
    HeadModel:SetModel(ply:GetModel())
    HeadModel:SetCamPos(ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")) + Vector(20, 0, 0))

    -- Dessinez le DModelPanel à l'écran
    HeadModel:SetPos(elemPos["model"].x, elemPos["model"].y)
    HeadModel:PaintManual()

    local base22 = "hud_base_4"
    local basename = "base_2"
    local health_x, health_y = elemPos["health"].x, elemPos["health"].y
    if (armor > 0) then
        base22 = "hud_base_7"
        basename = "base_22"
        health_x = elemPos["health"].armorPos.x
        health_y = elemPos["health"].armorPos.y
    end

    // draw health bar
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.SetMaterial(FogoHUD.Materials[base22])
    surface.DrawTexturedRect(elemPos[basename].x, elemPos[basename].y, elemPos[basename].w, elemPos[basename].h)

    // draw health bar (rounded rectangle)
    local health_coef = lerp_health / health_max
    draw.RoundedBox(6, health_x, health_y, elemPos["health"].w, elemPos["health"].h, FogoHUD.GetColor("health_obscured"))
    draw.RoundedBox(6, health_x + ((elemPos["health"].w / 2) - (elemPos["health"].w * health_coef) / 2), health_y, elemPos["health"].w * health_coef, elemPos["health"].h, FogoHUD.GetColor("health"))

    // mana bar
    local mana_coef = lerp_mana / mana_max
    draw.RoundedBox(6, elemPos["mana"].x, elemPos["mana"].y, elemPos["mana"].w, elemPos["mana"].h, FogoHUD.GetColor("mana_obscured"))
    draw.RoundedBox(6, elemPos["mana"].x + ((elemPos["mana"].w / 2) - (elemPos["mana"].w * mana_coef) / 2), elemPos["mana"].y, elemPos["mana"].w * mana_coef, elemPos["mana"].h, FogoHUD.GetColor("mana"))

    if (armor > 0) then
        // armor
        local armor_coef = lerp_armor / armor_max
        draw.RoundedBox(6, elemPos["armor"].x, elemPos["armor"].y, elemPos["armor"].w, elemPos["armor"].h, FogoHUD.GetColor("armor_obscured"))
        draw.RoundedBox(6, elemPos["armor"].x + ((elemPos["armor"].w / 2) - (elemPos["armor"].w * armor_coef) / 2), elemPos["armor"].y, elemPos["armor"].w * armor_coef, elemPos["armor"].h, FogoHUD.GetColor("armor"))
    end

    for k, v in pairs(elemPos) do
        if (!v.text || !v.parent || (armor == 0 && v.armor)) then continue end

        local new_x, new_y = v.x, v.y
        if (armor > 0 && v.armorPos) then
            new_x = v.armorPos.x
            new_y = v.armorPos.y
        end

        draw.SimpleText(funcElement[k](ply), "FogoFont:Naruto:16", new_x, new_y, v.color || FogoHUD.GetColor("text"), v.aling || TEXT_ALIGN_LEFT, v.aling || TEXT_ALIGN_LEFT)
    end
end)