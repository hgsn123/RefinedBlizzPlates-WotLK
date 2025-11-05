
if GetLocale() ~= "esES" then return end

select(2, ...).Blacklist = {
	-- NPC's plates as icons
	["Confalón de batalla de la Alianza"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["Confalón de batalla de Pico Tormenta"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["Confalón de batalla de la Horda"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["Confalón de batalla Lobo Gélido"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["Maligno de las Sombras"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Shadowfiend",
	["Espíritu de lobo"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Spirit_Wolf",
	["Elemental de agua"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Water_Elemental",
	["Antárbol"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Treant",
	["Culebra venenosa"] = "nterface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Venomous_Snake",
	["Víbora"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Viper",
	["Ejército de muertos"] = "Interface\\Icons\\Spell_DeathKnight_ArmyOfTheDead",
	["Necrófago resucitado"] = "Interface\\Icons\\Spell_Shadow_AnimateDead",
	-- NPC's plates hidden
	["Clarividente de la Luna Negra"] = "",
	["Drix Llavenegra"] = "",
	["Gnimo"] = "",
	["Hakmud de Argus"] = "",
	["Imagen del archimago Vargoth"] = "",
	["Diablillo en bola"] = "",
	["Mojodishu"] = "",
	["Tótem de espíritus"] = "",
	["Reflejo exacto"] = "",
	["Lamentadora de Sylvanas"] = "",
}