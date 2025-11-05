
if GetLocale() ~= "frFR" then return end

select(2, ...).Blacklist = {
	-- NPC's plates as icons
	["Etendard de bataille de l'Alliance"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["Etendard de bataille Foudrepique"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["Etendard de bataille de la Horde"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["Etendard de bataille loup-de-givre"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["Ombrefiel"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Shadowfiend",
	["Esprit du loup"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Spirit_Wolf",
	["Elémentaire d’eau"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Water_Elemental",
	["Tréant"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Treant",
    ["Serpent venimeux"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Venomous_Snake",
	["Vipère"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Viper",
	["Armée des morts"] = "Interface\\Icons\\Spell_DeathKnight_ArmyOfTheDead",
	["Goule ressuscitée"] = "Interface\\Icons\\Spell_Shadow_AnimateDead",
	-- NPC's plates hidden
	["Diseuse de bonne aventure de la foire de Sombrelune"] = "",
	["Drix Finsterzang"] = "",
	["Image de l’archimage Vargoth"] = "",
	["Gnimo"] = "",
	["Hakmud d'Argus"] = "",
	["Diabloboule"] = "",
	["Mojodishu"] = "",
	["Totem des esprits"] = "",
	["Image miroir"] = "",
	["Pleureuse de Sylvanas"] = "",
}