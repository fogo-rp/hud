if !LinvLib || LinvLib.Info.version < "0.3.3" then
    print(" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    print(" -                                                                                         - ")
    print(" -                      Linventif Library is outdated or not installed.                    - ")
    print(" -            Informations and Download Links : https://linv.dev/docs/#library             - ")
    print(" -                                                                                         - ")
    print(" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    return
end

// -- // -- // -- // -- // -- // -- // -- // -- // -- //

local folder = "fogo_hud"
local name = "Fogo HUD"
local license = "Commercial"
local version = "0.1.0"

FogoHUD = {
    ["Config"] = {},
    ["Materials"] = {},
    ["Fonts"] = {},
    ["Info"] = {
        ["name"] = name,
        ["version"] = version,
        ["folder"] = folder,
        ["license"] = license
    },
}

// -- // -- // -- // -- // -- // -- // -- // -- // -- //

LinvLib.Install[folder] = version
LinvLib.ShowAddonInfos(name, version, license)
LinvLib.LoadLocalizations(folder, name)
LinvLib.LoadAllFiles(folder, name)

//
// Add workshop
//

if SERVER then
    -- resource.AddWorkshop("xxx")
    print("| Fogo HUD | Workshop added")
end
