
if GetLocale() ~= "koKR" then return end

select(2, ...).Blacklist = {
	-- NPC's plates as icons
	["얼라이언스 전투 깃발"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["스톰파이크 전투깃발"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["호드 전투 깃발"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["서리늑대 전투깃발"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["어둠의 마귀"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Shadowfiend",
	["늑대 정령"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Spirit_Wolf",
	["물의 정령"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Water_Elemental",
	["나무정령"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Treant",
	["살무사"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Venomous_Snake",
	["독사"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Viper",
	["사자의 군대"] = "Interface\\Icons\\Spell_DeathKnight_ArmyOfTheDead",
	["되살아난 구울"] = "Interface\\Icons\\Spell_Shadow_AnimateDead",
	-- NPC's plates hidden
	["다크문 점술사"] = "",
	["드릭스 블랙렌치"] = "",
	["니모"] = "",
	["아르거스의 하크무드"] = "",
	["대마법사 바르고스의 환영"] = "",
	["구슬 속의 임프"] = "",
	["모조디슈"] = "",
	["정기의 토템"] = "",
	["복제된 환영"] = "",
	["애가를 부르는 실바나스의 밴시"] = "",
}