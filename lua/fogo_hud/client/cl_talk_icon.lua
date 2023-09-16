local VoiceIsActived = false
local PlayerVoicePanels = {}

function draw.RotatedBox(x, y, w, h)
    local Rotating = math.sin(CurTime() * 3)
        local backwards = 0

        if Rotating < 0 then
            Rotating = 1 - (1 + Rotating)
        backwards = 1
    end

    surface.SetMaterial(FogoHUD.materials["talk"])
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawTexturedRectRotated(x, y, Rotating * 64, 64,  backwards)
end

hook.Add("HUDPaint", "FogoHUD:HUDPaint", function()
    if VoiceIsActived then
        draw.RotatedBox( ScrW()-55, ScrH()/2-32, 64, 64)
    end
end)

hook.Add("PlayerStartVoice", "FogoHUD:PlayerStartVoice", function(ply)
    Material("voice/icntlk_pl"):SetFloat("$alpha", 0)
    if ply == LocalPlayer() then
        VoiceIsActived = true
    end
end)

hook.Add("PlayerEndVoice", "FogoHUD:PlayerEndVoice", function(ply)
    if ply == LocalPlayer() then
        VoiceIsActived = false
    end
end)