local iAlpha = 0
local tWeapons = {}
local iCurrentSlot = 0
local iCurrentWeapon = 1
local iMaxSlots = 6
local bDrawSelector = false

for k, v in ipairs(LocalPlayer():GetWeapons()) do
    tWeapons[v:GetSlot()] = tWeapons[v:GetSlot()] or {}
    local sPrintName = v:GetPrintName()
    if Prisel.WeaponSelector.WeaponsLabel[v:GetClass()] then
        sPrintName = Prisel.WeaponSelector.WeaponsLabel[v:GetClass()]
    end
    table.insert(tWeapons[v:GetSlot()], {v:GetClass(), sPrintName, v:GetSlot(), v})
end

function Prisel.WeaponSelector:GetWeaponsSlot(iSlot)
    return tWeapons[iSlot]
end

function Prisel.WeaponSelector:CountWeaponsSlot(iSlot)
    return #tWeapons[iSlot]
end

function Prisel.WeaponSelector:CountSlots()
    return table.Count(tWeapons)
end

function Prisel.WeaponSelector:NextSlot()
    iCurrentSlot = (iCurrentSlot + 1) % (iMaxSlots + 1)

    while tWeapons[iCurrentSlot] == nil do
        iCurrentSlot = (iCurrentSlot + 1) % (iMaxSlots + 1)
    end

    iCurrentWeapon = 1
end

function Prisel.WeaponSelector:NextWeapon()
    if iCurrentWeapon == 0 then
        iCurrentWeapon = 1
    else
        iCurrentWeapon = iCurrentWeapon + 1
    end

    local weaponsInSlot = Prisel.WeaponSelector:GetWeaponsSlot(iCurrentSlot)
    
    if iCurrentWeapon > Prisel.WeaponSelector:CountWeaponsSlot(iCurrentSlot) then
        iCurrentWeapon = 1
    end
end

function Prisel.WeaponSelector:PreviousSlot()
    iCurrentSlot = (iCurrentSlot - 1) % (iMaxSlots + 1)

    while tWeapons[iCurrentSlot] == nil do
        iCurrentSlot = (iCurrentSlot - 1) % (iMaxSlots + 1)
    end

    iCurrentWeapon = #tWeapons[iCurrentSlot]
end

function Prisel.WeaponSelector:PreviousWeapon()
    if iCurrentWeapon == 1 then
        local weaponsInSlot = Prisel.WeaponSelector:GetWeaponsSlot(iCurrentSlot)
        iCurrentWeapon = Prisel.WeaponSelector:CountWeaponsSlot(iCurrentSlot)
    else
        iCurrentWeapon = iCurrentWeapon - 1
    end
end

function Prisel.WeaponSelector:DrawSelector()
    bDrawSelector = true

    if timer.Exists("P.WeaponSelector.DrawSelector") then
        timer.Remove("P.WeaponSelector.DrawSelector")
    end

    timer.Create("P.WeaponSelector.DrawSelector", 2, 1, function()
        bDrawSelector = false
    end)
end

function Prisel.WeaponSelector:MouseScroll(pPlayer, sBind)
    if sBind == "invprev" and not pPlayer:KeyDown(IN_ATTACK) then
        Prisel.WeaponSelector:DrawSelector()
        if (iCurrentWeapon - 1) < 1 then
            Prisel.WeaponSelector:PreviousSlot()
        else
            Prisel.WeaponSelector:PreviousWeapon()
        end
    elseif sBind == "invnext" and not pPlayer:KeyDown(IN_ATTACK) then
        Prisel.WeaponSelector:DrawSelector()
        if (iCurrentWeapon + 1) > Prisel.WeaponSelector:CountWeaponsSlot(iCurrentSlot) then
            Prisel.WeaponSelector:NextSlot()
        else
            Prisel.WeaponSelector:NextWeapon()
        end
    elseif sBind == "+attack" and bDrawSelector then
        bDrawSelector = false
        timer.Remove("P.WeaponSelector.DrawSelector")
        print(Prisel.WeaponSelector:GetWeaponsSlot(iCurrentSlot)[iCurrentWeapon][1])
        input.SelectWeapon(Prisel.WeaponSelector:GetWeaponsSlot(iCurrentSlot)[iCurrentWeapon][4])
    end
end

hook.Add("HUDPaint", "P.WeaponSelector.DrawSelector", function()
    if bDrawSelector then

        for i = 0, iMaxSlots do
            if tWeapons[i] then
                local slotLabel = Prisel.WeaponSelector.SlotsLabel[i] or i
                surface.SetFont(DarkRP.Library.Font(8))
                local iW = surface.GetTextSize(slotLabel) + DarkRP.ScrW * 0.05

                local iX = DarkRP.ScrH * 0.2 * i - iW / 2 + DarkRP.ScrH / 2.5
                local iY = ScrH() * 0.005

                local iH = 50

                BSHADOWS.BeginShadow()
                    draw.RoundedBox(0, iX, iY, iW, iH, DarkRP.Library.AlphaColor(DarkRP.Config.Colors["Secondary"], i == iCurrentSlot and 255 or 100))
                BSHADOWS.EndShadow(1, 2, 2, 255, 0, 0, false)

                draw.SimpleText(Prisel.WeaponSelector.SlotsLabel[i] or i, DarkRP.Library.Font(8), iX + iW / 2, iY + iH / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                if i == iCurrentSlot then
                    local weaponCount = Prisel.WeaponSelector:CountWeaponsSlot(iCurrentSlot)
                    for j = 1, weaponCount do
                        local weaponName = Prisel.WeaponSelector:GetWeaponsSlot(iCurrentSlot)[j][2]
                        local iX = iX
                        local iY = iY + iH/2 + (j * DarkRP.ScrH * 0.05) - DarkRP.ScrH * 0.05 / 4
                        local iW = iW
                        local iH = 50

                        BSHADOWS.BeginShadow()
                            draw.RoundedBox(0, iX, iY, iW, iH, j == iCurrentWeapon and DarkRP.Config.Colors["Blue"] or DarkRP.Config.Colors["Secondary"])
                        BSHADOWS.EndShadow(1, 2, 2, 255, 0, 0, false)

                        draw.SimpleText(weaponName, DarkRP.Library.Font(8), iX + iW / 2, iY + iH / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                end
            end
        end
    end
end)
