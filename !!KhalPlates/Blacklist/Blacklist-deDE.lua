
if GetLocale() ~= "deDE" then return end

select(2, ...).Blacklist = {
	-- NPC's plates as icons
	["Schlachtstandarte der Allianz"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["Schlachtstandarte der Sturmlanzen"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["Schlachtstandarte der Horde"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["Schlachtstandarte der Frostwölfe"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["Schattengeist"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Shadowfiend",
	["Geisterwolf"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Spirit_Wolf",
	["Wasserelementar"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Water_Elemental",
	["Treant"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Treant",
    ["Giftige Schlange"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Venomous_Snake",
	["Viper"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Viper",
	["Armee der Toten"] = "Interface\\Icons\\Spell_DeathKnight_ArmyOfTheDead",
	["Auferstandener Ghul"] = "Interface\\Icons\\Spell_Shadow_AnimateDead",
	-- NPC's plates hidden
	["Wahrsager des Dunkelmond-Jahrmarkts"] = "",
	["Drix Blackwrench"] = "",
	["Gnimo"] = "",
	["Hakmud von Argus"] = "",
	["Abbild von Erzmagier Vargoth"] = "",
	["Wichtel in der Kugel"] = "",
	["Mojodishu"] = "",
	["Totem der Geister"] = "",
	["Spiegelbild"] = "",
	["Sylvanas' Klageweib"] = "",
}