
hook.Add("PlayerBindPress", "P.WeaponSelector.Select", Prisel.WeaponSelector.MouseScroll)

hook.Add("HUDShouldDraw", "P.WeaponSelector.RemoveDefault", Prisel.WeaponSelector.RemoveDefaultSelector)
