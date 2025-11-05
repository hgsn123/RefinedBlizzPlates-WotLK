
if GetLocale() ~= "ruRU" then return end

select(2, ...).Blacklist = {
	-- NPC's plates as icons
	["Боевой штандарт Альянса"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["Боевой штандарт клана Грозовой Вершины"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["Боевой штандарт Орды"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["Боевой штандарт клана Северного Волка"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["Исчадие Тьмы"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Shadowfiend",
	["Дух волка"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Spirit_Wolf",
	["Элементаль воды"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Water_Elemental",
	["Древень"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Treant",
    ["Ядовитая змея"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Venomous_Snake",
	["Гадюка"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Viper",
	["Войско мертвых"] = "Interface\\Icons\\Spell_DeathKnight_ArmyOfTheDead",
	["Восставший вурдалак"] = "Interface\\Icons\\Spell_Shadow_AnimateDead",
	-- NPC's plates hidden
	["Предсказательница ярмарки Новолуния"] = "",
	["Дрикс Злобноверт"] = "",
	["Гнимо"] = "",
	["Хакмуд из Аргуса"] = "",
	["Проекция верховного мага Варгота"] = "",
	["Бес в шаре"] = "",
	["Моджодишу"] = "",
	["Тотем духов"] = "",
	["Зеркальное изображение"] = "",
	["Плакальщица Сильваны"] = "",
}