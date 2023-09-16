local langs = {
    ["mana"] = "Mana",
    ["halth"] = "Vie",
    ["armor"] = "Armure"
}

function FogoHUD.GetLanguage(name, options)
    if (!name || !langs[name]) then return (name && name or "invalid") end

    if (options) then
        local rtnString = langs[name]

        for k, v in pairs(options) do
            rtnString = string.Replace(rtnString, "{" .. k .. "}", v)
        end

        return rtnString
    else
        return langs[name]
    end
end