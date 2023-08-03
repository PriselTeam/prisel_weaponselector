
hook.Add("PlayerBindPress", "P.WeaponSelector.Select", function(pPlayer, sBind)
    Prisel.WeaponSelector:MouseScroll(pPlayer, sBind)
end)

hook.Add("HUDShouldDraw", "P.WeaponSelector.RemoveDefault", function(sName)
    if sName == "CHudWeaponSelection" then return false end
end)