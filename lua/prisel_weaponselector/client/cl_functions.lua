local iAlpha = 0
local tWeapons = {}

for k, v in ipairs(LocalPlayer():GetWeapons()) do
    tWeapons[#tWeapons + 1] = {
        Slot = v:GetSlot(),
        Name = v:GetPrintName(),
        Class = v:GetClass(),

    }

    print(v:GetSlot())
end


function Prisel.WeaponSelector.MouseScroll(pPlayer, sBind)
    if sBind == "invprev" and not pPlayer:KeyDown(IN_ATTACK) then
        print("Prev")
    elseif sBind == "invnext" and not pPlayer:KeyDown(IN_ATTACK) then
        print("Next")
    elseif sBind == "+attack" then
        print("Select")
    end
end

function Prisel.WeaponSelector.RemoveDefaultSelector(sName)
    if sName == "CHudWeaponSelection" then return false end
end