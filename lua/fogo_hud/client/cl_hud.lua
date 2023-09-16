local function RespW(x)
    return x/1920*ScrW()
end

local function RespH(y)
    return y/1080*ScrH()
end

local elemPos = {
    ["base"] = {
        x = 5,
        y = -5,
        w = 368,
        h = 132,
    },
    ["model"] = {
        x = 21 + 5,
        y = 21 + 5,
        w = 90 - 10,
        h = 90 - 10,
    },
    ["name"] = {
        x = 117,
        y = 21,
        w = 230,
        h = 26,
    },
    ["job"] = {
        x = 117,
        y = 53,
        w = 230,
        h = 26,
    },
    ["money"] = {
        x = 117,
        y = 85,
        w = 230,
        h = 26,
    },
}

local multi = 1.3

elemPos["base"].w = RespW(elemPos["base"].w * multi)
elemPos["base"].h = RespH(elemPos["base"].h * multi)
elemPos["base"].x = RespW(elemPos["base"].x)
elemPos["base"].y = ScrH() - RespH(elemPos["base"].h) + RespH(elemPos["base"].y)

// for every element in elemPos table, multiply by multi
for k, v in pairs(elemPos) do
    if (k == "base") then continue end

    elemPos[k].w = RespW(elemPos[k].w * multi)
    elemPos[k].h = RespH(elemPos[k].h * multi)

    elemPos[k].x = elemPos["base"].x + RespW(elemPos[k].x * multi)
    elemPos[k].y = elemPos["base"].y + RespH(elemPos[k].y * multi)
end

local prefix = {
    ["name"] = "Nom: ",
    ["job"] = "Metier: ",
    ["money"] = "Argent: ",
}

local funcElement = {
    ["name"] = function(ply)
        return ply:Nick()
    end,
    ["job"] = function(ply)
        return ply:getDarkRPVar("job") or "Unknow"
    end,
    ["money"] = function(ply)
        return "$"..ply:getDarkRPVar("money") or 0
    end,
}

// TODO: fix this (don't show on connect, and don't hide when hud sould be hidden)
local HeadModel = vgui.Create("DModelPanel")
HeadModel:SetSize(elemPos["model"].w, elemPos["model"].h)
HeadModel:SetPos(0, 0)
HeadModel:SetModel("models/player/kleiner.mdl")

-- Ajustez la caméra pour cibler la tête
function HeadModel:LayoutEntity(Entity)
    self:SetLookAt(Entity:GetBonePosition(Entity:LookupBone("ValveBiped.Bip01_Head1")))
    self:SetCamPos(Entity:GetBonePosition(Entity:LookupBone("ValveBiped.Bip01_Head1")) + Vector(20, 0, 0))
end

hook.Add("HUDPaint", "FogoHUD:Paint", function()
    local ply = LocalPlayer()
    if not IsValid(ply) || not ply:Alive() then
        return
    end

    local health = ply:Health()
    local health_max = ply:GetMaxHealth()
    local armor = ply:Armor()
    local armor_max = ply:GetMaxArmor()

    local job = ply:getDarkRPVar("job") or "Unknow"
    local salary = ply:getDarkRPVar("salary") or 0
    local wallet = ply:getDarkRPVar("money") or 0

    // show hud base (image - FogoHUD.Materials("plyInfo.png"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(FogoHUD.Materials["hud_base_2"])
    surface.DrawTexturedRect(elemPos["base"].x, elemPos["base"].y, elemPos["base"].w, elemPos["base"].h)

    // draw a rectangle for element
    -- for k, v in pairs(elemPos) do
    --     if (k == "base") then continue end

    --     surface.SetDrawColor(143, 76, 76, 66, 128)
    --     surface.DrawRect(v.x, v.y, v.w, v.h)
    -- end

    for k, v in pairs(elemPos) do
        if (k == "base" || k == "model") then continue end

        draw.SimpleText(prefix[k]..funcElement[k](ply), "FogoFont:Naruto:20", v.x + 5, v.y + 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    end

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    -- Mettez à jour le modèle en fonction du joueur local
    HeadModel:SetModel(ply:GetModel())
    HeadModel:SetCamPos(ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")) + Vector(20, 0, 0))

    -- Dessinez le DModelPanel à l'écran
    HeadModel:SetPos(elemPos["model"].x, elemPos["model"].y)
    HeadModel:PaintManual()
end)
