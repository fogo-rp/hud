local colors = {
    ["health"] = Color(234, 94, 94),
    ["health_obscured"] = Color(168, 66, 66),
    ["armor"] = Color(70, 67, 198),
    ["armor_obscured"] = Color(46, 44, 153),
    ["mana"] = Color(67, 130, 198),
    ["mana_obscured"] = Color(46, 90, 137),
    ["text"] = Color(173, 173, 173),
    ["white"] = Color (255, 255, 255),
}

function FogoHUD.GetColor(name)
    return colors[name] or Color(255, 255, 255)
end