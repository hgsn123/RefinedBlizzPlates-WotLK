
if GetLocale() ~= "zhCN" then return end

select(2, ...).Blacklist = {
	-- NPC's plates as icons
	["联盟军旗"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["雷矛军旗"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Alliance_Battle_Standard",
	["部落军旗"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["霜狼军旗"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Horde_Battle_Standard",
	["暗影魔"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Shadowfiend",
	["幽灵狼"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Spirit_Wolf",
	["水元素"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Water_Elemental",
	["树人"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Treant",
	["剧毒蛇"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Venomous_Snake",
	["毒蛇"] = "Interface\\AddOns\\!!KhalPlates\\Assets\\Icons\\Viper",
	["亡者大军"] = "Interface\\Icons\\Spell_DeathKnight_ArmyOfTheDead",
	["复活的食尸鬼"] = "Interface\\Icons\\Spell_Shadow_AnimateDead",
	-- NPC's plates hidden
	["暗月占卜师"] = "",
	["德里克斯·黑钳"] = "",
	["尼莫"] = "",
	["阿古斯的哈克穆德"] = "",
	["大法师瓦格斯的影像"] = "",
	["球中的小鬼"] = "",
	["莫吉蒂"] = "",
	["灵魂图腾"] = "",
	["镜像"] = "",
	["希尔瓦娜斯的挽歌者"] = "",
}