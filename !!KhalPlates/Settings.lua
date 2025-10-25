
local AddonFile, KP = ... -- namespace

----------------------------- API -----------------------------
local ipairs, unpack, select, tonumber, math_floor, CreateFrame, UnitCastingInfo, UnitChannelInfo, UnitName =
      ipairs, unpack, select, tonumber, math.floor, CreateFrame, UnitCastingInfo, UnitChannelInfo, UnitName

------------------------- Core Variables -------------------------
local VirtualPlates = {}  -- Storage table for Virtual nameplate frames
local RealPlates = {}     -- Storage table for real nameplate frames
local PlatesVisible = {}  -- Storage table: currently active nameplates
local ASSETS = "Interface\\AddOns\\" .. AddonFile .. "\\Assets\\"
local MEDIA = "Interface\\AddOns\\" .. AddonFile .. "\\Media\\"
local NP_WIDTH = 156.65118520899 -- Nameplate original width (don't modify)
local NP_HEIGHT = 39.162796302247 -- Nameplate original height (don't modify)

------------- Database -------------
KP.default = {}
KP.default.profile = {}
KP.dbp = KP.default.profile

-------------------- Default Settings --------------------
KP.dbp.globalOffsetX = 0  -- Global offset X for nameplates
KP.dbp.globalOffsetY = 21 -- Global offset Y for nameplates
KP.dbp.globalScale = 1    -- Global scale for nameplates
KP.dbp.levelFilter = 1    -- Minimum unit level to show its nameplate
-- Runtime references for previous values in profile changes
KP.globalOffsetX = KP.dbp.globalOffsetX
KP.globalOffsetY = KP.dbp.globalOffsetY
-- Name Text
KP.dbp.nameText_hide = false
KP.dbp.nameText_font = "Arial Narrow"
KP.dbp.nameText_size = 9
KP.dbp.nameText_outline = ""
KP.dbp.nameText_anchor = "CENTER"
KP.dbp.nameText_offsetX = 0
KP.dbp.nameText_offsetY = 0
KP.dbp.nameText_width = 85 -- max text width before truncation (...)
KP.dbp.nameText_color = {1, 1, 1} -- white
-- Level Text
KP.dbp.levelText_hide = true
KP.dbp.levelText_font = "Arial Narrow"
KP.dbp.levelText_size = 12
KP.dbp.levelText_outline = ""
KP.dbp.levelText_anchor = "Right"
KP.dbp.levelText_offsetX = 0
KP.dbp.levelText_offsetY = 0
-- HealthBar
KP.dbp.healthBar_border = "KhalPlates"
KP.dbp.healthBar_borderTint = {1, 1, 1} -- This a tint overlay, not a regular color
KP.dbp.healthBar_playerTex = "KhalBar"
KP.dbp.healthBar_npcTex = "KhalBar"
KP.dbp.targetGlow_Tint = {1, 1, 1} -- This a tint overlay, not a regular color
KP.dbp.mouseoverGlow_Tint = {1, 1, 1} -- This a tint overlay, not a regular color
-- Health Text
KP.dbp.healthText_hide = false
KP.dbp.healthText_font = "Arial Narrow"
KP.dbp.healthText_size = 8.8
KP.dbp.healthText_outline = ""
KP.dbp.healthText_anchor = "RIGHT"
KP.dbp.healthText_offsetX = 0
KP.dbp.healthText_offsetY = 0
KP.dbp.healthText_color = {1, 1, 1} -- white
-- CastBar
KP.dbp.castBar_Tex = "KhalBar"
-- Cast Text
KP.dbp.castText_hide = false
KP.dbp.castText_font = "Arial Narrow"
KP.dbp.castText_size = 9
KP.dbp.castText_outline = ""
KP.dbp.castText_anchor = "CENTER"
KP.dbp.castText_offsetX = 0
KP.dbp.castText_offsetY = 0
KP.dbp.castText_width = 90 -- max text width before truncation (...)
KP.dbp.castText_color = {1, 1, 1} -- white
-- Cast Timer Text
KP.dbp.castTimerText_hide = false
KP.dbp.castTimerText_font = "Arial Narrow"
KP.dbp.castTimerText_size = 8.8
KP.dbp.castTimerText_outline = ""
KP.dbp.castTimerText_anchor = "RIGHT"
KP.dbp.castTimerText_offsetX = 0
KP.dbp.castTimerText_offsetY = 0
KP.dbp.castTimerText_color = {1, 1, 1} -- white
-- Elite Icon
KP.dbp.eliteIcon_anchor = "LEFT"
KP.dbp.eliteIcon_Tint = {1, 1, 1}
-- Boss Icon
KP.dbp.bossIcon_size = 18
KP.dbp.bossIcon_anchor = "Right"
KP.dbp.bossIcon_offsetX = 0
KP.dbp.bossIcon_offsetY = 0
-- Raid Target Icon
KP.dbp.raidTargetIcon_size = 27
KP.dbp.raidTargetIcon_anchor = "Right"
KP.dbp.raidTargetIcon_offsetX = 0
KP.dbp.raidTargetIcon_offsetY = 0
-- Class Icon (in Arenas and BGs)
KP.dbp.showClassOnFriends = true
KP.dbp.showClassOnEnemies = true
KP.dbp.classIcon_size = 26
KP.dbp.classIcon_anchor = "Left"
KP.dbp.classIcon_offsetX = 0
KP.dbp.classIcon_offsetY = 0
-- Totem Plates
KP.dbp.totemSize = 23 -- Size of the totem (or NPC) icon replacing the nameplate
KP.dbp.totemOffset = 0 -- Vertical offset for totem icon

------------------- Shared Media -------------------
local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("statusbar", "Blizzard Nameplates", "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
LSM:Register("statusbar", "AceBarFrames", MEDIA .. "Textures\\AceBarFrames")
LSM:Register("statusbar", "Aluminium", MEDIA .. "Textures\\Aluminium")
LSM:Register("statusbar", "Armory", MEDIA .. "Textures\\Armory")
LSM:Register("statusbar", "BantoBar", MEDIA .. "Textures\\BantoBar")
LSM:Register("statusbar", "BantoBarReverse", MEDIA .. "Textures\\BantoBarReverse")
LSM:Register("statusbar", "Bars", MEDIA .. "Textures\\Bars")
LSM:Register("statusbar", "blend", MEDIA .. "Textures\\blend")
LSM:Register("statusbar", "Blinkii", MEDIA .. "Textures\\Blinkii")
LSM:Register("statusbar", "Bumps", MEDIA .. "Textures\\Bumps")
LSM:Register("statusbar", "Button", MEDIA .. "Textures\\Button")
LSM:Register("statusbar", "Cilo", MEDIA .. "Textures\\Cilo")
LSM:Register("statusbar", "Charcoal", MEDIA .. "Textures\\Charcoal")
LSM:Register("statusbar", "Clean", MEDIA .. "Textures\\Clean")
LSM:Register("statusbar", "Cloud", MEDIA .. "Textures\\Cloud")
LSM:Register("statusbar", "Comet", MEDIA .. "Textures\\Comet")
LSM:Register("statusbar", "Dabs", MEDIA .. "Textures\\Dabs")
LSM:Register("statusbar", "DarkBottom", MEDIA .. "Textures\\DarkBottom")
LSM:Register("statusbar", "Diagonal", MEDIA .. "Textures\\Diagonal")
LSM:Register("statusbar", "Falumn", MEDIA .. "Textures\\Falumn")
LSM:Register("statusbar", "Ferous 1", MEDIA .. "Textures\\Ferous1")
LSM:Register("statusbar", "Ferous 2", MEDIA .. "Textures\\Ferous2")
LSM:Register("statusbar", "Ferous 3", MEDIA .. "Textures\\Ferous3")
LSM:Register("statusbar", "Ferous 4", MEDIA .. "Textures\\Ferous4")
LSM:Register("statusbar", "Ferous 5", MEDIA .. "Textures\\Ferous5")
LSM:Register("statusbar", "Ferous 6", MEDIA .. "Textures\\Ferous6")
LSM:Register("statusbar", "Ferous 7", MEDIA .. "Textures\\Ferous7")
LSM:Register("statusbar", "Ferous 8", MEDIA .. "Textures\\Ferous8")
LSM:Register("statusbar", "Ferous 9", MEDIA .. "Textures\\Ferous9")
LSM:Register("statusbar", "Ferous 10", MEDIA .. "Textures\\Ferous10")
LSM:Register("statusbar", "Ferous 11", MEDIA .. "Textures\\Ferous11")
LSM:Register("statusbar", "Ferous 12", MEDIA .. "Textures\\Ferous12")
LSM:Register("statusbar", "Ferous 13", MEDIA .. "Textures\\Ferous13")
LSM:Register("statusbar", "Ferous 14", MEDIA .. "Textures\\Ferous14")
LSM:Register("statusbar", "Ferous 15", MEDIA .. "Textures\\Ferous15")
LSM:Register("statusbar", "Ferous 16", MEDIA .. "Textures\\Ferous16")
LSM:Register("statusbar", "Ferous 17", MEDIA .. "Textures\\Ferous17")
LSM:Register("statusbar", "Ferous 18", MEDIA .. "Textures\\Ferous18")
LSM:Register("statusbar", "Ferous 19", MEDIA .. "Textures\\Ferous19")
LSM:Register("statusbar", "Ferous 20", MEDIA .. "Textures\\Ferous20")
LSM:Register("statusbar", "Ferous 21", MEDIA .. "Textures\\Ferous21")
LSM:Register("statusbar", "Ferous 22", MEDIA .. "Textures\\Ferous22")
LSM:Register("statusbar", "Ferous 23", MEDIA .. "Textures\\Ferous23")
LSM:Register("statusbar", "Ferous 24", MEDIA .. "Textures\\Ferous24")
LSM:Register("statusbar", "Ferous 25", MEDIA .. "Textures\\Ferous25")
LSM:Register("statusbar", "Ferous 26", MEDIA .. "Textures\\Ferous26")
LSM:Register("statusbar", "Ferous 27", MEDIA .. "Textures\\Ferous27")
LSM:Register("statusbar", "Ferous 28", MEDIA .. "Textures\\Ferous28")
LSM:Register("statusbar", "Ferous 29", MEDIA .. "Textures\\Ferous29")
LSM:Register("statusbar", "Ferous 30", MEDIA .. "Textures\\Ferous30")
LSM:Register("statusbar", "Ferous 31", MEDIA .. "Textures\\Ferous31")
LSM:Register("statusbar", "Ferous 32", MEDIA .. "Textures\\Ferous32")
LSM:Register("statusbar", "Ferous 33", MEDIA .. "Textures\\Ferous33")
LSM:Register("statusbar", "Ferous 34", MEDIA .. "Textures\\Ferous34")
LSM:Register("statusbar", "Ferous 35", MEDIA .. "Textures\\Ferous35")
LSM:Register("statusbar", "Fifths", MEDIA .. "Textures\\Fifths")
LSM:Register("statusbar", "Flat", MEDIA .. "Textures\\Flat")
LSM:Register("statusbar", "Frost", MEDIA .. "Textures\\Frost")
LSM:Register("statusbar", "Fourths", MEDIA .. "Textures\\Fourths")
LSM:Register("statusbar", "Glamour", MEDIA .. "Textures\\Glamour")
LSM:Register("statusbar", "Glamour2", MEDIA .. "Textures\\Glamour2")
LSM:Register("statusbar", "Glamour3", MEDIA .. "Textures\\Glamour3")
LSM:Register("statusbar", "Glamour4", MEDIA .. "Textures\\Glamour4")
LSM:Register("statusbar", "Glamour5", MEDIA .. "Textures\\Glamour5")
LSM:Register("statusbar", "Glamour6", MEDIA .. "Textures\\Glamour6")
LSM:Register("statusbar", "Glamour7", MEDIA .. "Textures\\Glamour7")
LSM:Register("statusbar", "Glass", MEDIA .. "Textures\\Glass")
LSM:Register("statusbar", "Glaze", MEDIA .. "Textures\\Glaze")
LSM:Register("statusbar", "Gloss", MEDIA .. "Textures\\Gloss")
LSM:Register("statusbar", "Gradient", MEDIA .. "Textures\\Gradient")
LSM:Register("statusbar", "Graphite", MEDIA .. "Textures\\Graphite")
LSM:Register("statusbar", "Grid", MEDIA .. "Textures\\Grid")
LSM:Register("statusbar", "Hatched", MEDIA .. "Textures\\Hatched")
LSM:Register("statusbar", "Healbot", MEDIA .. "Textures\\Healbot")
LSM:Register("statusbar", "KhalBar", MEDIA .. "Textures\\KhalBar")
LSM:Register("statusbar", "LiteStep", MEDIA .. "Textures\\LiteStep")
LSM:Register("statusbar", "LiteStepLite", MEDIA .. "Textures\\LiteStepLite")
LSM:Register("statusbar", "Lyfe", MEDIA .. "Textures\\Lyfe")
LSM:Register("statusbar", "Melli", MEDIA .. "Textures\\Melli")
LSM:Register("statusbar", "Melli Dark", MEDIA .. "Textures\\MelliDark")
LSM:Register("statusbar", "Melli Dark Rough", MEDIA .. "Textures\\MelliDarkRough")
LSM:Register("statusbar", "Minimalist", MEDIA .. "Textures\\Minimalist")
LSM:Register("statusbar", "Norm", MEDIA .. "Textures\\Norm")
LSM:Register("statusbar", "Otravi", MEDIA .. "Textures\\Otravi")
LSM:Register("statusbar", "Perl", MEDIA .. "Textures\\Perl")
LSM:Register("statusbar", "Perl v2", MEDIA .. "Textures\\Perl2")
LSM:Register("statusbar", "Raeli 1", MEDIA .. "Textures\\Raeli1.tga")
LSM:Register("statusbar", "Raeli 2", MEDIA .. "Textures\\Raeli2.tga")
LSM:Register("statusbar", "Raeli 3", MEDIA .. "Textures\\Raeli3.tga")
LSM:Register("statusbar", "Raeli 4", MEDIA .. "Textures\\Raeli4.tga")
LSM:Register("statusbar", "Raeli 5", MEDIA .. "Textures\\Raeli5.tga")
LSM:Register("statusbar", "Raeli 6", MEDIA .. "Textures\\Raeli6.tga")
LSM:Register("statusbar", "Rain", MEDIA .. "Textures\\Rain")
LSM:Register("statusbar", "Rocks", MEDIA .. "Textures\\Rocks")
LSM:Register("statusbar", "Ruben", MEDIA .. "Textures\\Ruben")
LSM:Register("statusbar", "Runes", MEDIA .. "Textures\\Runes")
LSM:Register("statusbar", "Skewed", MEDIA .. "Textures\\Skewed")
LSM:Register("statusbar", "Smooth", MEDIA .. "Textures\\Smooth")
LSM:Register("statusbar", "Smooth v2", MEDIA .. "Textures\\Smoothv2")
LSM:Register("statusbar", "Smudge", MEDIA .. "Textures\\Smudge")
LSM:Register("statusbar", "Steel", MEDIA .. "Textures\\Steel")
LSM:Register("statusbar", "Striped", MEDIA .. "Textures\\Striped")
LSM:Register("statusbar", "Stripes", MEDIA .. "Textures\\Stripes")
LSM:Register("statusbar", "Thick Stripes", MEDIA .. "Textures\\Thick Stripes")
LSM:Register("statusbar", "Thin Stripes", MEDIA .. "Textures\\Thin Stripes")
LSM:Register("statusbar", "ToxiUI Clean", MEDIA .. "Textures\\ToxiUI-clean")
LSM:Register("statusbar", "ToxiUI Dark", MEDIA .. "Textures\\ToxiUI-dark")
LSM:Register("statusbar", "Water", MEDIA .. "Textures\\Water")
LSM:Register("statusbar", "Wglass", MEDIA .. "Textures\\Wglass")
LSM:Register("statusbar", "Wisps", MEDIA .. "Textures\\Wisps")
LSM:Register("statusbar", "Xeon", MEDIA .. "Textures\\Xeon")
LSM:Register("font", "Accidental Presidency", MEDIA .. "Fonts\\AccidentalPresidency.ttf")
LSM:Register("font", "Action Man", MEDIA .. "Fonts\\ActionMan.ttf")
LSM:Register("font", "Adventure", MEDIA .. "Fonts\\Adventure.ttf")
LSM:Register("font", "Alba Super", MEDIA .. "Fonts\\AlbaSuper.ttf")
LSM:Register("font", "All Hooked Up", MEDIA .. "Fonts\\AllHookedUp.ttf")
LSM:Register("font", "Ancient Geek", MEDIA .. "Fonts\\AncientGeek.ttf")
LSM:Register("font", "Arm Wrestler", MEDIA .. "Fonts\\ArmWrestler.ttf")
LSM:Register("font", "Augustus", MEDIA .. "Fonts\\Augustus.ttf")
LSM:Register("font", "Aurora", MEDIA .. "Fonts\\Aurora.ttf")
LSM:Register("font", "Aurora Extended", MEDIA .. "Fonts\\AuroraExtended.ttf")
LSM:Register("font", "AvantGarde LT Medium", MEDIA .. "Fonts\\AvantGardeLTMedium.ttf")
LSM:Register("font", "AvantGarde LT Bold", MEDIA .. "Fonts\\AvantGardeLTBold.ttf")
LSM:Register("font", "Avanti", MEDIA .. "Fonts\\Avanti.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "AvQest", MEDIA .. "Fonts\\AvQest.ttf")
LSM:Register("font", "Baar Sophia", MEDIA .. "Fonts\\BaarSophia.ttf")
LSM:Register("font", "Bavaria", MEDIA .. "Fonts\\Bavaria.ttf")
LSM:Register("font", "Bavaria Extended", MEDIA .. "Fonts\\BavariaExtended.ttf")
LSM:Register("font", "Bazooka", MEDIA .. "Fonts\\Bazooka.ttf")
LSM:Register("font", "BigNoodleToo", MEDIA .. "Fonts\\BigNoodleToo.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "BigNoodleTitling", MEDIA .. "Fonts\\BigNoodleTitling.ttf")
LSM:Register("font", "Black Chancery", MEDIA .. "Fonts\\BlackChancery.ttf")
LSM:Register("font", "Blazed", MEDIA .. "Fonts\\Blazed.ttf")
LSM:Register("font", "Blender Pro", MEDIA .. "Fonts\\BlenderPro.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Blender Pro Bold", MEDIA .. "Fonts\\BlenderProBold.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Blender Pro Heavy", MEDIA .. "Fonts\\BlenderProHeavy.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Boris Black Bloxx Dirty", MEDIA .. "Fonts\\BorisBlackBloxxDirty.ttf")
LSM:Register("font", "Boris Black Bloxx", MEDIA .. "Fonts\\BorisBlackBloxx.ttf")
LSM:Register("font", "Caesar", MEDIA .. "Fonts\\Caesar.ttf")
LSM:Register("font", "Capitalis Type Oasis", MEDIA .. "Fonts\\CapitalisTypeOasis.ttf")
LSM:Register("font", "Celestia Medium Redux", MEDIA .. "Fonts\\CelestiaMediumRedux.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Collegiate", MEDIA .. "Fonts\\Collegiate.ttf")
LSM:Register("font", "Cooline", MEDIA .. "Fonts\\Cooline.ttf")
LSM:Register("font", "Continuum Medium", MEDIA .. "Fonts\\ContinuumMedium.ttf")
LSM:Register("font", "DejaVu Sans", MEDIA .. "Fonts\\DejaVuLGCSans.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "DejaVu Serif", MEDIA .. "Fonts\\DejaVuLGCSerif.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "DieDieDie", MEDIA .. "Fonts\\DieDieDie.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Diogenes", MEDIA .. "Fonts\\Diogenes.ttf")
LSM:Register("font", "Disko", MEDIA .. "Fonts\\Disko.ttf")
LSM:Register("font", "Disney Heroic", MEDIA .. "Fonts\\DisneyHeroic.ttf")
LSM:Register("font", "Doris PP", MEDIA .. "Fonts\\DorisPP.ttf")
LSM:Register("font", "Emblem", MEDIA .. "Fonts\\Emblem.ttf")
LSM:Register("font", "Enigmatic", MEDIA .. "Fonts\\Enigmatic.ttf")
LSM:Register("font", "Eurasia", MEDIA .. "Fonts\\Eurasia.ttf")
LSM:Register("font", "Exocet Blizzard Light", MEDIA .. "Fonts\\ExocetBlizzardLight.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Exocet Blizzard Medium", MEDIA .. "Fonts\\ExocetBlizzardMedium.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Expressway", MEDIA .. "Fonts\\Expressway.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Fira Mono Medium", MEDIA .. "Fonts\\FiraMonoMedium.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Fitzgerald", MEDIA .. "Fonts\\Fitzgerald.ttf")
LSM:Register("font", "FORCED SQUARE", MEDIA .. "Fonts\\FORCEDSQUARE.ttf")
LSM:Register("font", "Frakturika Spamless", MEDIA .. "Fonts\\FrakturikaSpamless.ttf")
LSM:Register("font", "FrancoisOne", MEDIA .. "Fonts\\FrancoisOne.ttf")
LSM:Register("font", "Frucade", MEDIA .. "Fonts\\Frucade.ttf")
LSM:Register("font", "Frucade Small", MEDIA .. "Fonts\\FrucadeSmall.ttf")
LSM:Register("font", "Frucade Medium", MEDIA .. "Fonts\\FrucadeMedium.ttf")
LSM:Register("font", "Frucade Extended", MEDIA .. "Fonts\\FrucadeExtended.ttf")
LSM:Register("font", "Futura PT Bold", MEDIA .. "Fonts\\FuturaPTBold.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Futura PT Book", MEDIA .. "Fonts\\FuturaPTBook.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Futura PT Medium", MEDIA .. "Fonts\\FuturaPTMedium.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Gentium Plus", MEDIA .. "Fonts\\GentiumPlus.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Germanica Embossed", MEDIA .. "Fonts\\GermanicaEmbossed.ttf")
LSM:Register("font", "Germanica Fluted", MEDIA .. "Fonts\\GermanicaFluted.ttf")
LSM:Register("font", "Germanica Shadowed", MEDIA .. "Fonts\\GermanicaShadowed.ttf")
LSM:Register("font", "Ginko", MEDIA .. "Fonts\\Ginko.ttf")
LSM:Register("font", "Gotham Ultra", MEDIA .. "Fonts\\GothamUltra.ttf")
LSM:Register("font", "Gros", MEDIA .. "Fonts\\Gros.ttf")
LSM:Register("font", "Gros Extended", MEDIA .. "Fonts\\GrosExtended.ttf")
LSM:Register("font", "Hack", MEDIA .. "Fonts\\Hack.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Harry Potter", MEDIA .. "Fonts\\HarryP.ttf")
LSM:Register("font", "Homespun", MEDIA .. "Fonts\\Homespun.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Impact", MEDIA .. "Fonts\\Impact.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "King Arthur Legend", MEDIA .. "Fonts\\KingArthurLegend.ttf")
LSM:Register("font", "Liberation Sans", MEDIA .. "Fonts\\LiberationSans.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Liberation Serif", MEDIA .. "Fonts\\LiberationSerif.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Marke Eigenbau", MEDIA .. "Fonts\\MarkeEigenbau.ttf")
LSM:Register("font", "Memoria Extended", MEDIA .. "Fonts\\MemoriaExtended.ttf")
LSM:Register("font", "Memoria", MEDIA .. "Fonts\\Memoria.ttf")
LSM:Register("font", "Micro", MEDIA .. "Fonts\\Micro.ttf")
LSM:Register("font", "Myriad Condensed Web", MEDIA .. "Fonts\\MyriadCondensedWeb.ttf")
LSM:Register("font", "Munica Extended", MEDIA .. "Fonts\\MunicaExtended.ttf")
LSM:Register("font", "Munica", MEDIA .. "Fonts\\Munica.ttf")
LSM:Register("font", "Mystic Orbs", MEDIA .. "Fonts\\MysticOrbs.ttf")
LSM:Register("font", "Nueva Std Cond", MEDIA .. "Fonts\\NuevaStdCond.ttf")
LSM:Register("font", "Olde English", MEDIA .. "Fonts\\OldeEnglish.ttf")
LSM:Register("font", "Oswald", MEDIA .. "Fonts\\Oswald.ttf")
LSM:Register("font", "Pokemon Solid", MEDIA .. "Fonts\\PokemonSolid.ttf")
LSM:Register("font", "Porky", MEDIA .. "Fonts\\Porky.ttf")
LSM:Register("font", "Prototype", MEDIA .. "Fonts\\Prototype.ttf")
LSM:Register("font", "PT Sans Narrow", MEDIA .. "Fonts\\PTSansNarrow.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Quicksand", MEDIA .. "Fonts\\Quicksand.ttf")
LSM:Register("font", "RM Midserif", MEDIA .. "Fonts\\RMMidserif.ttf")
LSM:Register("font", "Rock Show Whiplash", MEDIA .. "Fonts\\RockShowWhiplash.ttf")
LSM:Register("font", "Roman SD", MEDIA .. "Fonts\\RomanSD.ttf")
LSM:Register("font", "Romanum Est", MEDIA .. "Fonts\\RomanumEst.ttf")
LSM:Register("font", "Semplice Extended", MEDIA .. "Fonts\\SempliceExtended.ttf")
LSM:Register("font", "Semplice", MEDIA .. "Fonts\\Semplice.ttf")
LSM:Register("font", "SF Atarian System", MEDIA .. "Fonts\\SFAtarianSystem.ttf")
LSM:Register("font", "SF Covington", MEDIA .. "Fonts\\SFCovington.ttf")
LSM:Register("font", "SF Diego Sans", MEDIA .. "Fonts\\SFDiegoSans.ttf")
LSM:Register("font", "SF Movie Poster", MEDIA .. "Fonts\\SFMoviePoster.ttf")
LSM:Register("font", "SF Wonder Comic", MEDIA .. "Fonts\\SFWonderComic.ttf")
LSM:Register("font", "Solange", MEDIA .. "Fonts\\Solange.ttf")
LSM:Register("font", "Star Cine", MEDIA .. "Fonts\\StarCine.ttf")
LSM:Register("font", "Steelfish Rg", MEDIA .. "Fonts\\SteelfishRg.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "SWF!T", MEDIA .. "Fonts\\SWF!T.ttf")
LSM:Register("font", "Talismanica", MEDIA .. "Fonts\\Talismanica.ttf")
LSM:Register("font", "Taurus", MEDIA .. "Fonts\\Taurus.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Tellural Alt", MEDIA .. "Fonts\\TelluralAlt.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "TGL", MEDIA .. "Fonts\\TGL.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Transformers", MEDIA .. "Fonts\\Transformers.ttf")
LSM:Register("font", "Trashco", MEDIA .. "Fonts\\Trashco.ttf")
LSM:Register("font", "TrashHand", MEDIA .. "Fonts\\TrashHand.ttf")
LSM:Register("font", "Triatlhon In", MEDIA .. "Fonts\\TriatlhonIn.ttf")
LSM:Register("font", "Tw Cen MT", MEDIA .. "Fonts\\TwCenMT.ttf")
LSM:Register("font", "Ubuntu Condensed", MEDIA .. "Fonts\\UbuntuCondensed.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Ubuntu Light", MEDIA .. "Fonts\\UbuntuLight.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Ultima Campagnoli", MEDIA .. "Fonts\\UltimaCampagnoli.ttf")
LSM:Register("font", "Waltograph UI", MEDIA .. "Fonts\\WaltographUI.ttf")
LSM:Register("font", "WenQuanYi Zen Hei", MEDIA .. "Fonts\\WenQuanYiZenHei.ttf", LSM.LOCALE_BIT_koKR + LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_zhCN + LSM.LOCALE_BIT_zhTW + LSM.LOCALE_BIT_western)
LSM:Register("font", "X360", MEDIA .. "Fonts\\X360.ttf", LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
LSM:Register("font", "Yanone Kaffeesatz Regular", MEDIA .. "Fonts\\YanoneKaffeesatzRegular.ttf")
LSM:Register("font", "Yellowjacket", MEDIA .. "Fonts\\Yellowjacket.ttf")

KP.MainOptionTable = {
	name = "KhalPlates",
	type = "group",
	childGroups = "tab",
	get = function(info)
        return KP.dbp[info[#info]]
    end,
	set = function(info, val)
        KP.dbp[info[#info]] = val
    end,
	args = {
		tab1 = {
			order = 1,
			name = "General",
			type = "group",
			args = {
				blank1 = {
					order = 1,
					type = "description",
					name = "",
				},
				general_header = {
					order = 2,
					type = "header",
					name = "General Settings",
				},
				blank2 = {
					order = 3,
					type = "description",
					name = "",
				},
				healthBar_border = {
					order = 4,
					type = "select",
					name = "Nameplate Style",
					values = {
						["KhalPlates"] = "KhalPlates",
						["Blizzard"] = "Blizzard",
					},
					set = function(info, val)
						KP.dbp[info[#info]] = val
						if val == "KhalPlates" then
							KP.dbp.globalOffsetX = 0
							KP.dbp.nameText_font = "Arial Narrow"
							KP.dbp.nameText_size = 9
							KP.dbp.nameText_offsetX = 0
							KP.dbp.nameText_offsetY = 0
							KP.dbp.nameText_width = 85
							KP.dbp.levelText_hide = true
							KP.dbp.levelText_font = "Arial Narrow"
							KP.dbp.levelText_size = 12				
							KP.dbp.healthText_font = "Arial Narrow"
							KP.dbp.healthText_size = 8.8
							KP.dbp.healthText_anchor = "RIGHT"
							KP.dbp.healthText_offsetX = 0
							KP.dbp.healthText_offsetY = 0
							KP.dbp.castText_font = "Arial Narrow"
							KP.dbp.castText_size = 9
							KP.dbp.castText_offsetY = 0
							KP.dbp.castTimerText_font = "Arial Narrow"
							KP.dbp.castTimerText_size = 8.8
							KP.dbp.healthBar_playerTex = "KhalBar"
							KP.dbp.healthBar_npcTex = "KhalBar"
							KP.dbp.castBar_Tex = "KhalBar"
							KP.dbp.eliteIcon_anchor = "LEFT"
							KP.dbp.raidTargetIcon_size = 27
							KP.dbp.raidTargetIcon_anchor = "Right"
							KP.dbp.classIcon_size = 26
							KP.dbp.classIcon_anchor = "Left"
						else
							KP.dbp.globalOffsetX = -11
							KP.dbp.nameText_font = "Friz Quadrata TT"
							KP.dbp.nameText_size = 16
							KP.dbp.nameText_offsetX = 11
							KP.dbp.nameText_offsetY = 17
							KP.dbp.nameText_width = 250
							KP.dbp.levelText_hide = false
							KP.dbp.levelText_font = "Friz Quadrata TT"
							KP.dbp.levelText_size = 14
							KP.dbp.healthText_font = "Friz Quadrata TT"
							KP.dbp.healthText_size = 9.5
							KP.dbp.healthText_anchor = "CENTER"
							KP.dbp.healthText_offsetX = 11
							KP.dbp.healthText_offsetY = -0.2
							KP.dbp.castText_font = "Friz Quadrata TT"
							KP.dbp.castText_size = 10
							KP.dbp.castText_offsetY = -0.4
							KP.dbp.castTimerText_font = "Friz Quadrata TT"
							KP.dbp.castTimerText_size = 9.5
							KP.dbp.healthBar_playerTex = "Blizzard Nameplates"
							KP.dbp.healthBar_npcTex = "Blizzard Nameplates"
							KP.dbp.castBar_Tex = "Blizzard Nameplates"
							KP.dbp.eliteIcon_anchor = "RIGHT"
							KP.dbp.raidTargetIcon_size = 35
							KP.dbp.raidTargetIcon_anchor = "Top"
							KP.dbp.classIcon_size = 35
							KP.dbp.classIcon_anchor = "Top"
						end
						KP.dbp.nameText_anchor = "CENTER"
						KP.dbp.levelText_outline = ""
						KP.dbp.levelText_anchor = "Right"
						KP.dbp.levelText_offsetX = 0
						KP.dbp.levelText_offsetY = 0
						KP.dbp.castText_anchor = "CENTER"
						KP.dbp.castText_outline = ""
						KP.dbp.castText_width = 90
						KP.dbp.castText_offsetX = 0
						KP.dbp.castTimerText_outline = ""
						KP.dbp.castTimerText_anchor = "RIGHT"
						KP.dbp.castTimerText_offsetX = 0
						KP.dbp.castTimerText_offsetY = 0
						KP.dbp.bossIcon_anchor = "Right"
						KP.dbp.bossIcon_size = 18
						KP.dbp.bossIcon_offsetX = 0
						KP.dbp.bossIcon_offsetY = 0
						KP.dbp.raidTargetIcon_offsetX = 0
						KP.dbp.raidTargetIcon_offsetY = 0
						KP.dbp.classIcon_offsetX = 0
						KP.dbp.classIcon_offsetY = 0
						KP:MoveAllVisiblePlates(KP.dbp.globalOffsetX - KP.globalOffsetX, 0)
						KP:UpdateAllNameTexts()
						KP:UpdateAllLevelTexts()
						KP:UpdateAllHealthBars()
						KP:UpdateAllCastBarBorders()
						KP:UpdateAllCastBars()
						KP:UpdateAllGlows()
						KP:UpdateAllIcons()
						KP.globalOffsetX = KP.dbp.globalOffsetX
					end,
				},
				blank3 = {
					order = 5,
					type = "description",
					name = "",
				},
				blank4 = {
					order = 6,
					type = "description",
					name = "",
				},
				blank5 = {
					order = 7,
					type = "description",
					name = "",
				},
				globalScale = {
					order = 8,
					type = "range",
					name = "Global Scale",
					desc = "Affects mainly the visual nameplate.\nThe hitbox can only be scaled out of combat, and it will restore its original size when hidden; so if shown during combat, it will scale once combat ends.",
					min = 0.5,
					max = 2.5,
					step = 0.01,
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP:UpdateAllVirtualsScale()
					end,
				},
				blank6 = {
					order = 9,
					type = "description",
					name = "",
				},
				blank7 = {
					order = 10,
					type = "description",
					name = "",
				},
				blank8 = {
					order = 11,
					type = "description",
					name = "",
				},
				globalOffsetX = {
					order = 12,
					type = "range",
					name = "Global Offset X",
					desc = "Affects only the visual nameplate.\nThe real hitbox can't be moved.",
					min = -50,
					max = 50,
					step = 1,
					set = function(info, val)
						KP.dbp.globalOffsetX = val
						KP:MoveAllVisiblePlates(KP.dbp.globalOffsetX - KP.globalOffsetX, 0)
						KP.globalOffsetX = KP.dbp.globalOffsetX
					end,
				},
				globalOffsetY = {
					order = 13,
					type = "range",
					name = "Global Offset Y",
					desc = "Affects only the visual nameplate.\nThe real hitbox can't be moved.",
					min = -50,
					max = 50,
					step = 1,
					set = function(info, val)
						KP.dbp.globalOffsetY = val
						KP:MoveAllVisiblePlates(0, KP.dbp.globalOffsetY - KP.globalOffsetY)
						KP.globalOffsetY = KP.dbp.globalOffsetY
					end,
				},
				blank9 = {
					order = 14,
					type = "description",
					name = "",
				},
				blank10 = {
					order = 15,
					type = "description",
					name = "",
				},
				blank11 = {
					order = 165,
					type = "description",
					name = "",
				},
				levelFilter = {
					order = 17,
					type = "range",
					name = "Level Filter",
					desc = "Minimum unit level required for the nameplate to be shown.",
					min = 1,
					max = 80,
					step = 1,
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP:UpdateLevelFilter()
					end,
				},
			},
		},
		tab2 = {
			order = 2,
			name = "Health Bar",
			type = "group",
			set = function(info, val)
				KP.dbp[info[#info]] = val
				KP:UpdateAllHealthBars()
			end,
			args = {
				blank1 = {
					order = 1,
					type = "description",
					name = "",
				},
				healthBar_header = {
					order = 2,
					type = "header",
					name = "Appearance",
				},
				blank2 = {
					order = 3,
					type = "description",
					name = "",
				},
				healthBar_playerTex = {
					order = 4,
					type = "select",
					name = "Player Bar Texture",
					dialogControl = "LSM30_Statusbar",
					values = AceGUIWidgetLSMlists.statusbar,
				},			
				healthBar_npcTex = {
					order = 5,
					type = "select",
					name = "NPC Bar Texture",
					dialogControl = "LSM30_Statusbar",
					values = AceGUIWidgetLSMlists.statusbar,
				},
				blank3 = {
					order = 6,
					type = "description",
					name = "",
				},
				healthBar_borderTint = {
					order = 7,
					type = "color",
					name = "Border Tint",
					desc = "This is a tint overlay, not a regular color. 'White' keeps the original look.",
					get = function(info)
						local c = KP.dbp[info[#info]]
						return c[1], c[2], c[3]
					end,
					set = function(info, r, g, b)
						KP.dbp[info[#info]] = {r, g, b}
						KP:UpdateAllHealthBars()
					end,
				},
				blank4 = {
					order = 8,
					type = "description",
					name = "",
				},
				blank5 = {
					order = 9,
					type = "description",
					name = "",
				},
				healthBarGlow_header = {
					order = 10,
					type = "header",
					name = "Glows",
				},
				blank6 = {
					order = 11,
					type = "description",
					name = "",
				},
				targetGlow_Tint = {
					order = 12,
					type = "color",
					name = "Target Glow Tint",
					desc = "This is a tint overlay, not a regular color. 'White' keeps the original look.",
					get = function(info)
						local c = KP.dbp[info[#info]]
						return c[1], c[2], c[3]
					end,
					set = function(info, r, g, b)
						KP.dbp[info[#info]] = {r, g, b}
						KP:UpdateAllGlows()
					end,
				},
				mouseoverGlow_Tint = {
					order = 13,
					type = "color",
					name = "Mouseover Glow Tint",
					desc = "This is a tint overlay, not a regular color. 'White' keeps the original look.",
					get = function(info)
						local c = KP.dbp[info[#info]]
						return c[1], c[2], c[3]
					end,
					set = function(info, r, g, b)
						KP.dbp[info[#info]] = {r, g, b}
						KP:UpdateAllGlows()
					end,
				},
				blank7 = {
					order = 14,
					type = "description",
					name = "",
				},
				blank8 = {
					order = 15,
					type = "description",
					name = "",
				},
				healthText_header = {
					order = 16,
					type = "header",
					name = "Health Text",
				},
				blank9 = {
					order = 17,
					type = "description",
					name = "",
				},
				healthText_font = {
					order = 18,
					type = "select",
					name = "Text Font",
					values = LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					disabled = function() return KP.dbp.healthText_hide end
				},
				healthText_size = {
					order = 19,
					type = "range",
					name = "Font Size",
					min = 6,
					max = 18,
					step = 0.1,
					disabled = function() return KP.dbp.healthText_hide end
				},
				healthText_outline = {
					order = 20,
					type = "select", 
					name = "Outline",
					values = {
						[""] = "None",
						["OUTLINE"] = "Outline",
						["THICKOUTLINE"] = "Thick Outline",
						["MONOCHROME"] = "Monochrome",
						["OUTLINE,MONOCHROME"] = "Monochrome Outline",
						["THICKOUTLINE,MONOCHROME"] = "Monochrome Thick Outline",
					},
					disabled = function() return KP.dbp.healthText_hide end
				},
				healthText_anchor = {
					order = 21,
					type = "select", 
					name = "Anchor",
					values = {
						["LEFT"] = "Left",
						["CENTER"] = "Center",
						["RIGHT"] = "Right"
					},
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP.dbp.healthText_offsetX = 0
						KP.dbp.healthText_offsetY = 0
						KP:UpdateAllHealthBars()
					end,
					disabled = function() return KP.dbp.healthText_hide end
				},
				healthText_offsetX = {
					order = 22,
					type = "range",
					name = "Offset X",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.healthText_hide end
				},
				healthText_offsetY = {
					order = 23,
					type = "range",
					name = "Offset Y",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.healthText_hide end
				},
				healthText_color = {
					order = 24,
					type = "color",
					name = "Text Color",
					get = function(info)
						local c = KP.dbp[info[#info]]
						return c[1], c[2], c[3]
					end,
					set = function(info, r, g, b)
						KP.dbp[info[#info]] = {r, g, b}
						KP:UpdateAllHealthBars()
					end,
					disabled = function() return KP.dbp.healthText_hide end
				},
				healthText_hide = {
					order = 25,
					type = "toggle",
					name = "Hide Health Text",
				},
			},
		},
		tab3 = {
			order = 3,
			name = "Name/Level",
			type = "group",
			set = function(info, val)
				KP.dbp[info[#info]] = val
				KP:UpdateAllNameTexts()
				KP:UpdateAllLevelTexts()
			end,
			args = {
				blank1 = {
					order = 1,
					type = "description",
					name = "",
				},
				nameText_header = {
					order = 2,
					type = "header",
					name = "Name Text",
				},
				blank2 = {
					order = 3,
					type = "description",
					name = "",
				},
				nameText_font = {
					order = 4,
					type = "select",
					name = "Text Font",
					values = LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					disabled = function() return KP.dbp.nameText_hide end
				},
				nameText_size = {
					order = 5,
					type = "range",
					name = "Font Size",
					min = 6,
					max = 18,
					step = 0.1,
					disabled = function() return KP.dbp.nameText_hide end
				},
				nameText_outline = {
					order = 6,
					type = "select", 
					name = "Outline",
					values = {
						[""] = "None",
						["OUTLINE"] = "Outline",
						["THICKOUTLINE"] = "Thick Outline",
						["MONOCHROME"] = "Monochrome",
						["OUTLINE,MONOCHROME"] = "Monochrome Outline",
						["THICKOUTLINE,MONOCHROME"] = "Monochrome Thick Outline",
					},
					disabled = function() return KP.dbp.nameText_hide end
				},
				nameText_anchor = {
					order = 7,
					type = "select", 
					name = "Anchor",
					values = {
						["LEFT"] = "Left",
						["CENTER"] = "Center",
						["RIGHT"] = "Right"
					},
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP.dbp.nameText_offsetX = 0
						KP.dbp.nameText_offsetY = 0
						KP:UpdateAllNameTexts()
					end,
					disabled = function() return KP.dbp.nameText_hide end
				},
				nameText_offsetX = {
					order = 8,
					type = "range",
					name = "Offset X",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.nameText_hide end
				},
				nameText_offsetY = {
					order = 9,
					type = "range",
					name = "Offset Y",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.nameText_hide end
				},
				nameText_width = {
					order = 10,
					type = "range",
					name = "Width",
					min = 50,
					max = 250,
					step = 1,
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP:UpdateAllNameTexts()
					end,
					disabled = function() return KP.dbp.nameText_hide end
				},
				nameText_color = {
					order = 11,
					type = "color",
					name = "Text Color",
					get = function(info)
						local c = KP.dbp[info[#info]]
						return c[1], c[2], c[3]
					end,
					set = function(info, r, g, b)
						KP.dbp[info[#info]] = {r, g, b}
						KP:UpdateAllNameTexts()
					end,
					disabled = function() return KP.dbp.nameText_hide end
				},
				nameText_hide = {
					order = 12,
					type = "toggle",
					name = "Hide Name Text",
				},
				blank3 = {
					order = 13,
					type = "description",
					name = "",
				},
				blank4 = {
					order = 14,
					type = "description",
					name = "",
				},
				levelText_header = {
					order = 15,
					type = "header",
					name = "Level Text",
				},
				blank5 = {
					order = 16,
					type = "description",
					name = "",
				},
				levelText_font = {
					order = 17,
					type = "select",
					name = "Text Font",
					values = LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					disabled = function() return KP.dbp.levelText_hide end
				},
				levelText_size = {
					order = 18,
					type = "range",
					name = "Font Size",
					min = 8,
					max = 20,
					step = 0.1,
					disabled = function() return KP.dbp.levelText_hide end
				},
				levelText_outline = {
					order = 19,
					type = "select", 
					name = "Outline",
					values = {
						[""] = "None",
						["OUTLINE"] = "Outline",
						["THICKOUTLINE"] = "Thick Outline",
						["MONOCHROME"] = "Monochrome",
						["OUTLINE,MONOCHROME"] = "Monochrome Outline",
						["THICKOUTLINE,MONOCHROME"] = "Monochrome Thick Outline",
					},
					disabled = function() return KP.dbp.levelText_hide end
				},
				levelText_anchor = {
					order = 20,
					type = "select", 
					name = "Anchor",
					values = {
						["Left"] = "Left",
						["Center"] = "Center",
						["Right"] = "Right"
					},
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP.dbp.levelText_offsetX = 0
						KP.dbp.levelText_offsetY = 0
						KP:UpdateAllLevelTexts()
					end,
					disabled = function() return KP.dbp.levelText_hide end
				},
				levelText_offsetX = {
					order = 21,
					type = "range",
					name = "Offset X",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.levelText_hide end
				},
				levelText_offsetY = {
					order = 22,
					type = "range",
					name = "Offset Y",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.levelText_hide end
				},
				levelText_hide = {
					order = 23,
					type = "toggle",
					name = "Hide Level Text",
				},
			},
		},
		tab4 = {
			order = 4,
			name = "Cast Bar",
			type = "group",
			set = function(info, val)
				KP.dbp[info[#info]] = val
				KP:UpdateAllCastBars()
			end,
			args = {
				blank1 = {
					order = 1,
					type = "description",
					name = "",
				},
				castBar_header = {
					order = 2,
					type = "header",
					name = "Appearance",
				},
				blank2 = {
					order = 3,
					type = "description",
					name = "",
				},
				castBar_Tex = {
					order = 4,
					type = "select",
					name = "Bar Texture",
					dialogControl = "LSM30_Statusbar",
					values = AceGUIWidgetLSMlists.statusbar,
				},
				blank3 = {
					order = 5,
					type = "description",
					name = "",
				},
				blank4 = {
					order = 6,
					type = "description",
					name = "",
				},
				castText_header = {
					order = 7,
					type = "header",
					name = "Cast Text",
				},
				blank5 = {
					order = 8,
					type = "description",
					name = "",
				},
				castText_font = {
					order = 9,
					type = "select",
					name = "Text Font",
					values = LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					disabled = function() return KP.dbp.castText_hide end
				},
				castText_size = {
					order = 10,
					type = "range",
					name = "Font Size",
					min = 6,
					max = 18,
					step = 0.1,
					disabled = function() return KP.dbp.castText_hide end
				},
				castText_outline = {
					order = 11,
					type = "select", 
					name = "Outline",
					values = {
						[""] = "None",
						["OUTLINE"] = "Outline",
						["THICKOUTLINE"] = "Thick Outline",
						["MONOCHROME"] = "Monochrome",
						["OUTLINE,MONOCHROME"] = "Monochrome Outline",
						["THICKOUTLINE,MONOCHROME"] = "Monochrome Thick Outline",
					},
					disabled = function() return KP.dbp.castText_hide end
				},
				castText_anchor = {
					order = 12,
					type = "select", 
					name = "Anchor",
					values = {
						["LEFT"] = "Left",
						["CENTER"] = "Center",
						["RIGHT"] = "Right"
					},
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP.dbp.castText_offsetX = 0
						KP.dbp.castText_offsetY = 0
						KP:UpdateAllCastBars()
					end,
					disabled = function() return KP.dbp.castText_hide end
				},
				castText_offsetX = {
					order = 13,
					type = "range",
					name = "Offset X",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.castText_hide end
				},
				castText_offsetY = {
					order = 14,
					type = "range",
					name = "Offset Y",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.castText_hide end
				},
				castText_width = {
					order = 15,
					type = "range",
					name = "Width",
					min = 50,
					max = 250,
					step = 1,
					disabled = function() return KP.dbp.castText_hide end
				},
				castText_color = {
					order = 16,
					type = "color",
					name = "Text Color",
					get = function(info)
						local c = KP.dbp[info[#info]]
						return c[1], c[2], c[3]
					end,
					set = function(info, r, g, b)
						KP.dbp[info[#info]] = {r, g, b}
						KP:UpdateAllCastBars()
					end,
					disabled = function() return KP.dbp.castText_hide end
				},
				castText_hide = {
					order = 17,
					type = "toggle",
					name = "Hide Cast Text",
				},
				blank6 = {
					order = 18,
					type = "description",
					name = "",
				},
				blank7 = {
					order = 19,
					type = "description",
					name = "",
				},
				castTimerText_header = {
					order = 20,
					type = "header",
					name = "Cast Timer Text",
				},
				blank8 = {
					order = 21,
					type = "description",
					name = "",
				},
				castTimerText_font = {
					order = 22,
					type = "select",
					name = "Text Font",
					values = LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					disabled = function() return KP.dbp.castTimerText_hide end
				},
				castTimerText_size = {
					order = 23,
					type = "range",
					name = "Font Size",
					min = 6,
					max = 18,
					step = 0.1,
					disabled = function() return KP.dbp.castTimerText_hide end
				},
				castTimerText_outline = {
					order = 24,
					type = "select", 
					name = "Outline",
					values = {
						[""] = "None",
						["OUTLINE"] = "Outline",
						["THICKOUTLINE"] = "Thick Outline",
						["MONOCHROME"] = "Monochrome",
						["OUTLINE,MONOCHROME"] = "Monochrome Outline",
						["THICKOUTLINE,MONOCHROME"] = "Monochrome Thick Outline",
					},
					disabled = function() return KP.dbp.castTimerText_hide end
				},
				castTimerText_anchor = {
					order = 25,
					type = "select", 
					name = "Anchor",
					values = {
						["LEFT"] = "Left",
						["CENTER"] = "Center",
						["RIGHT"] = "Right"
					},
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP.dbp.castTimerText_offsetX = 0
						KP.dbp.castTimerText_offsetY = 0
						KP:UpdateAllCastBars()
					end,
					disabled = function() return KP.dbp.castTimerText_hide end
				},
				castTimerText_offsetX = {
					order = 26,
					type = "range",
					name = "Offset X",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.castTimerText_hide end
				},
				castTimerText_offsetY = {
					order = 27,
					type = "range",
					name = "Offset Y",
					min = -25,
					max = 25,
					step = 0.1,
					disabled = function() return KP.dbp.castTimerText_hide end
				},
				castTimerText_color = {
					order = 28,
					type = "color",
					name = "Text Color",
					get = function(info)
						local c = KP.dbp[info[#info]]
						return c[1], c[2], c[3]
					end,
					set = function(info, r, g, b)
						KP.dbp[info[#info]] = {r, g, b}
						KP:UpdateAllCastBars()
					end,
					disabled = function() return KP.dbp.castTimerText_hide end
				},
				castTimerText_hide = {
					order = 29,
					type = "toggle",
					name = "Hide Cast Timer Text",
				},
			},
		},
		tab5 = {
			order = 5,
			name = "Icons",
			type = "group",
			set = function(info, val)
				KP.dbp[info[#info]] = val
				KP:UpdateAllIcons()
			end,
			args = {
				blank1 = {
					order = 1,
					type = "description",
					name = "",
				},
				eliteIcon_header = {
					order = 2,
					type = "header",
					name = "Elite Icon",
				},
				blank2 = {
					order = 3,
					type = "description",
					name = "",
				},
				eliteIcon_anchor = {
					order = 4,
					type = "select", 
					name = "Anchor",
					values = {
						["LEFT"] = "Left",
						["RIGHT"] = "Right"
					},
				},
				eliteIcon_Tint = {
					order = 5,
					type = "color",
					name = "Tint",
					desc = "This is a tint overlay, not a regular color. 'White' keeps the original look.",
					get = function(info)
						local c = KP.dbp[info[#info]]
						return c[1], c[2], c[3]
					end,
					set = function(info, r, g, b)
						KP.dbp[info[#info]] = {r, g, b}
						KP:UpdateAllIcons()
					end,
				},
				blank3 = {
					order = 6,
					type = "description",
					name = "",
				},
				blank4 = {
					order = 7,
					type = "description",
					name = "",
				},
				bossIcon_header = {
					order = 8,
					type = "header",
					name = "Boss Icon",
				},
				blank5 = {
					order = 9,
					type = "description",
					name = "",
				},
				bossIcon_anchor = {
					order = 10,
					type = "select", 
					name = "Anchor",
					values = {
						["Left"] = "Left",
						["Center"] = "Center",
						["Right"] = "Right"
					},
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP.dbp.bossIcon_offsetX = 0
						KP.dbp.bossIcon_offsetY = 0
						KP:UpdateAllIcons()
					end,
				},
				bossIcon_offsetX = {
					order = 11,
					type = "range",
					name = "Offset X",
					min = -25,
					max = 25,
					step = 0.1,
				},
				bossIcon_offsetY = {
					order = 12,
					type = "range",
					name = "Offset Y",
					min = -25,
					max = 25,
					step = 0.1,
				},
				bossIcon_size = {
					order = 13,
					type = "range",
					name = "Icon Size",
					min = 15,
					max = 35,
					step = 0.1,
				},
				blank6 = {
					order = 14,
					type = "description",
					name = "",
				},
				blank7 = {
					order = 15,
					type = "description",
					name = "",
				},
				raidTargetIcon_header = {
					order = 16,
					type = "header",
					name = "Raid Target Icon",
				},
				blank8 = {
					order = 17,
					type = "description",
					name = "",
				},
				raidTargetIcon_anchor = {
					order = 18,
					type = "select", 
					name = "Anchor",
					values = {
						["Left"] = "Left",
						["Top"] = "Top",
						["Right"] = "Right"
					},
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP.dbp.raidTargetIcon_offsetX = 0
						KP.dbp.raidTargetIcon_offsetY = 0
						KP:UpdateAllIcons()
					end,
				},
				raidTargetIcon_offsetX = {
					order = 19,
					type = "range",
					name = "Offset X",
					min = -25,
					max = 25,
					step = 0.1,
				},
				raidTargetIcon_offsetY = {
					order = 20,
					type = "range",
					name = "Offset Y",
					min = -25,
					max = 25,
					step = 0.1,
				},
				raidTargetIcon_size = {
					order = 21,
					type = "range",
					name = "Icon Size",
					min = 20,
					max = 50,
					step = 0.1,
				},
				blank9 = {
					order = 22,
					type = "description",
					name = "",
				},
				blank10 = {
					order = 23,
					type = "description",
					name = "",
				},
				classIcon_header = {
					order = 24,
					type = "header",
					name = "Class Icon",
				},
				blank11 = {
					order = 25,
					type = "description",
					name = "",
				},
				classIcon_anchor = {
					order = 26,
					type = "select", 
					name = "Anchor",
					values = {
						["Left"] = "Left",
						["Top"] = "Top",
						["Right"] = "Right"
					},
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP.dbp.classIcon_offsetX = 0
						KP.dbp.classIcon_offsetY = 0
						KP:UpdateAllIcons()
					end,
				},
				classIcon_offsetX = {
					order = 27,
					type = "range",
					name = "Offset X",
					min = -25,
					max = 25,
					step = 0.1,
				},
				classIcon_offsetY = {
					order = 28,
					type = "range",
					name = "Offset Y",
					min = -25,
					max = 25,
					step = 0.1,
				},
				classIcon_size = {
					order = 29,
					type = "range",
					name = "Icon Size",
					min = 20,
					max = 50,
					step = 0.1,
				},
				showClassOnFriends = {
					order = 30,
					type = "toggle",
					name = "Show on Friends",
					desc = "Class icons are only shown in battlegrounds and arenas.",
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP:UpdateAllClassIcons()
					end,
				},
				showClassOnEnemies = {
					order = 31,
					type = "toggle",
					name = "Show on Enemies",
					desc = "Class icons are only shown in battlegrounds and arenas.",
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP:UpdateAllClassIcons()
					end,
				},
				blank12 = {
					order = 32,
					type = "description",
					name = "",
				},
				blank13 = {
					order = 33,
					type = "description",
					name = "",
				},
				totemIcon_header = {
					order = 34,
					type = "header",
					name = "Totem Icon",
				},
				blank14 = {
					order = 35,
					type = "description",
					name = "",
				},
				totemSize = {
					order = 36,
					type = "range",
					name = "Icon Size",
					min = 15,
					max = 35,
					step = 0.1,
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP:UpdateAllTotemPlates()
					end,
				},
				totemOffset = {
					order = 37,
					type = "range",
					name = "Offset Y",
					min = -25,
					max = 25,
					step = 0.1,
					set = function(info, val)
						KP.dbp[info[#info]] = val
						KP:UpdateAllTotemPlates()
					end,
				},
			},
		},
		tab6 = {
			order = 6,
			name = "Totems",
			type = "group",
			args = {
				blank1 = {
					order = 1,
					type = "description",
					name = "",
				},
				Totems_header = {
					order = 2,
					type = "header",
					name = "In Development",
				},
				blank2 = {
					order = 3,
					type = "description",
					name = "",
				}
			}						
		}
	}
}

KP.AboutTable = {
	name = "About",
	type = "group",
	childGroups = "tab",
	get = function(info)
		return KP.dbp[info[#info]]
	end,
	set = function(info, v)
		KP.dbp[info[#info]] = v
	end,
	args = (function()
		local args = {}
		local fields = {
			"Title",
			"Notes",
			"Version",
			"Author",
			"X-Date",
			"X-Repository",
		}
		for i, field in ipairs(fields) do
			local val = GetAddOnMetadata(AddonFile, field)
			if val then
				if field == "X-Repository" then
					args[field] = {
						type = "input",
						name = field:gsub("^X%-", ""),
						width = "double",
						order = i,
						get = function(info)
							return GetAddOnMetadata(AddonFile, info[#info])
						end,
					}
				else
					args[field] = {
						type = "description",
						name = "|cffffd100" .. field:gsub("^X%-", "") .. ": |r" .. val,
						width = "double",
						order = i,
					}
				end
			end
		end
		return args
	end)()
}

---------------------------- Customization Functions ----------------------------
-- Hash table mapping custom color keys to class names
local ClassByKey = {
	[761122] = "DEATHKNIGHT",
	[994803] = "DRUID",
	[668244] = "HUNTER",
	[407993] = "MAGE",
	[955472] = "PALADIN",
	[999999] = "PRIEST",
	[999540] = "ROGUE",
	[004386] = "SHAMAN",
	[575078] = "WARLOCK",
	[776042] = "WARRIOR",
	[000099] = "FRIENDLY", -- identifies friendly players
}

SetCVar("ShowClassColorInNameplate", 1) -- "Class Colors in Nameplates" must be enabled to identify enemy players

-- Converts normalized RGB from nameplates into a custom color key and returns the class name
local function ClassByPlateColor(healthBar)
	local r, g, b = healthBar:GetStatusBarColor()
	local key = floor(r * 100) * 10000 + floor(g * 100) * 100 + floor(b * 100)
	return ClassByKey[key]
end

local function SetupHealthBorder(healthBar)
	if healthBar.healthBarBorder then return end
	healthBar.healthBarBorder = healthBar:CreateTexture(nil, "ARTWORK")
	if KP.dbp.healthBar_border == "KhalPlates" then
		healthBar.healthBarBorder:SetTexture(ASSETS .. "HealthBar-Border")
	else
		healthBar.healthBarBorder:SetTexture("Interface\\Tooltips\\Nameplate-Border")
	end
	healthBar.healthBarBorder:SetVertexColor(unpack(KP.dbp.healthBar_borderTint))
	healthBar.healthBarBorder:SetSize(KP.NP_WIDTH, KP.NP_HEIGHT)
	healthBar.healthBarBorder:SetPoint("CENTER", 10.5, 9)
end


local function SetupBarBackground(Bar)
	if Bar.BackgroundTex then return end 
	Bar.BackgroundTex = Bar:CreateTexture(nil, "BACKGROUND")
	Bar.BackgroundTex:SetTexture(ASSETS .. "NamePlate-Background")
	Bar.BackgroundTex:SetSize(KP.NP_WIDTH, KP.NP_HEIGHT)
	Bar.BackgroundTex:SetPoint("CENTER", 10.5, 9)
end

local function SetupNameText(healthBar)
	if healthBar.nameText then return end
	healthBar.nameText = healthBar:CreateFontString(nil, "OVERLAY")
	healthBar.nameText:SetFont(LSM:Fetch("font", KP.dbp.nameText_font), KP.dbp.nameText_size, KP.dbp.nameText_outline)
	healthBar.nameText:ClearAllPoints()
	healthBar.nameText:SetPoint(KP.dbp.nameText_anchor, KP.dbp.nameText_offsetX + 0.2, KP.dbp.nameText_offsetY + 0.7)
	healthBar.nameText:SetWidth(KP.dbp.nameText_width)
	healthBar.nameText:SetJustifyH(KP.dbp.nameText_anchor)
	healthBar.nameText:SetTextColor(unpack(KP.dbp.nameText_color))
	healthBar.nameText:SetShadowOffset(0.5, -0.5)
	healthBar.nameText:SetNonSpaceWrap(false)
	healthBar.nameText:SetWordWrap(false)
	if KP.dbp.nameText_hide then
		healthBar.nameText:Hide()
	end
end

local function UpdateHealthTextValue(healthBar)
	local min, max = healthBar:GetMinMaxValues()
	local val = healthBar:GetValue()
	if max > 0 then
		local percent = math_floor((val / max) * 100)
		if percent < 100 and percent > 0 then
			healthBar.healthText:SetText(percent .. "%")
		else
			healthBar.healthText:SetText("")
		end
	else
		healthBar.healthText:SetText("")
	end
end

local function SetupHealthText(healthBar)
	if healthBar.healthText then return end
	healthBar.healthText = healthBar:CreateFontString(nil, "OVERLAY")
	healthBar.healthText:SetFont(LSM:Fetch("font", KP.dbp.healthText_font), KP.dbp.healthText_size, KP.dbp.healthText_outline)
	healthBar.healthText:SetPoint(KP.dbp.healthText_anchor, KP.dbp.healthText_offsetX, KP.dbp.healthText_offsetY + 0.3)
	healthBar.healthText:SetTextColor(unpack(KP.dbp.healthText_color))
	healthBar.healthText:SetShadowOffset(0.5, -0.5)
	UpdateHealthTextValue(healthBar)
	healthBar:HookScript("OnValueChanged", UpdateHealthTextValue)
	healthBar:HookScript("OnShow", UpdateHealthTextValue)
	if KP.dbp.healthText_hide then
		healthText:Hide()
	end
end

local function SetupTargetGlow(Virtual)
	local healthBar = Virtual.healthBar
	if healthBar.targetGlow then return end
	local RealPlate = KP.RealPlates[Virtual]
	healthBar.targetGlow = healthBar:CreateTexture(nil, "OVERLAY")
	healthBar.targetGlow:Hide()
	if KP.dbp.healthBar_border == "KhalPlates" then
		healthBar.targetGlow:SetTexture(ASSETS .. "HealthBar-TargetGlow")
		healthBar.targetGlow:SetSize(KP.NP_WIDTH, KP.NP_HEIGHT)
		healthBar.targetGlow:SetPoint("CENTER", 0.7, 0.5)
	else
		healthBar.targetGlow:SetTexture(ASSETS .. "HealthBar-TargetGlowBlizz")
		healthBar.targetGlow:SetSize(KP.NP_WIDTH * 1.165, KP.NP_HEIGHT)
		healthBar.targetGlow:SetPoint("CENTER", 11.33, 0.5)
	end
	healthBar.targetGlow:SetVertexColor(unpack(KP.dbp.targetGlow_Tint))
	healthBar.targetBorderDelay = CreateFrame("Frame")
	healthBar.targetBorderDelay:Hide()
	healthBar.targetBorderDelay:SetScript("OnUpdate", function(self)
		self:Hide()
		if healthBar.nameText:GetText() == UnitName("target") and Virtual:GetAlpha() == 1 then
			healthBar.targetGlow:Show()
			if RealPlate.totemPlate then RealPlate.totemPlate.targetGlow:Show() end
		else
			healthBar.targetGlow:Hide()
			if RealPlate.totemPlate then RealPlate.totemPlate.targetGlow:Hide() end
		end
	end)
end

local function UpdateTargetGlow(Virtual)
	Virtual.healthBar.targetBorderDelay:Show()
end

local function SetupCastText(castBar)
	if castBar.castText then return end
	castBar.castText = castBar:CreateFontString(nil, "OVERLAY")
	castBar.castText:SetFont(LSM:Fetch("font", KP.dbp.castText_font), KP.dbp.castText_size, KP.dbp.castText_outline)
	castBar.castText:SetWidth(KP.dbp.castText_width)
	castBar.castText:SetJustifyH(KP.dbp.castText_anchor)
	castBar.castText:SetTextColor(unpack(KP.dbp.castText_color))
	castBar.castText:SetNonSpaceWrap(false)
	castBar.castText:SetWordWrap(false)
	castBar.castText:SetShadowOffset(0.5, -0.5)
	if KP.dbp.healthBar_border == "KhalPlates" then
		castBar.castText:SetPoint(KP.dbp.castText_anchor, KP.dbp.castText_offsetX - 3.8, KP.dbp.castText_offsetY + 1.6)
	else
		castBar.castText:SetPoint(KP.dbp.castText_anchor, KP.dbp.castText_offsetX - 9.3, KP.dbp.castText_offsetY + 1.6)
	end
	if KP.dbp.castText_hide then
		castBar.castText:Hide()
	end
	castBar.castTextDelay = castBar.castTextDelay or CreateFrame("Frame")
	castBar.castTextDelay:Hide()
	castBar.castTextDelay:SetScript("OnUpdate", function(self)
		self:Hide()
		local unit = "target"
		local spellName = UnitCastingInfo(unit) or UnitChannelInfo(unit)
		castBar.castText:SetText(spellName)
	end)
	local function UpdateCastTextValue()
		castBar.castTextDelay:Show()
	end
	UpdateCastTextValue()
	castBar:HookScript("OnShow", UpdateCastTextValue)
end

local function SetupCastTimer(castBar)
	if castBar.castTimerText then return end
	castBar.castTimerText = castBar:CreateFontString(nil, "OVERLAY")
	castBar.castTimerText:SetFont(LSM:Fetch("font", KP.dbp.castTimerText_font), KP.dbp.castTimerText_size, KP.dbp.castTimerText_outline)
	castBar.castTimerText:SetTextColor(unpack(KP.dbp.castTimerText_color))
	castBar.castTimerText:SetShadowOffset(0.5, -0.5)
	castBar.castTimerText:SetPoint(KP.dbp.castTimerText_anchor, KP.dbp.castTimerText_offsetX - 2, KP.dbp.castTimerText_offsetY + 1)
	castBar:HookScript("OnValueChanged", function(self, val)
		local min, max = self:GetMinMaxValues()
		if max and val then
			local remaining = max - val
			if UnitChannelInfo("target") then
				self.castTimerText:SetFormattedText("%.1f", val)
			else
				self.castTimerText:SetFormattedText("%.1f", remaining)
			end
		end
	end)
end

local function UpdateClassIcon(Virtual)
	local classIcon = Virtual.classIcon
	classIcon:SetSize(KP.dbp.classIcon_size, KP.dbp.classIcon_size)
	classIcon:ClearAllPoints()
	if KP.dbp.healthBar_border == "KhalPlates" then
		if KP.dbp.classIcon_anchor == "Left" then
			classIcon:SetPoint("RIGHT", Virtual, "LEFT", KP.dbp.classIcon_offsetX + 16, KP.dbp.classIcon_offsetY + 11)
		elseif KP.dbp.classIcon_anchor == "Top" then
			classIcon:SetPoint("BOTTOM", Virtual, "TOP", KP.dbp.classIcon_offsetX, KP.dbp.classIcon_offsetY + 1.5)
		else
			classIcon:SetPoint("LEFT", Virtual, "RIGHT", KP.dbp.classIcon_offsetX - 15, KP.dbp.classIcon_offsetY + 11)
		end
	else
		if KP.dbp.classIcon_anchor == "Left" then
			classIcon:SetPoint("RIGHT", Virtual, "LEFT", KP.dbp.classIcon_offsetX + 4, KP.dbp.classIcon_offsetY + 12)
		elseif KP.dbp.classIcon_anchor == "Top" then
			classIcon:SetPoint("BOTTOM", Virtual, "TOP", KP.dbp.classIcon_offsetX, KP.dbp.classIcon_offsetY + 16)
		else
			classIcon:SetPoint("LEFT", Virtual, "RIGHT", KP.dbp.classIcon_offsetX - 4, KP.dbp.classIcon_offsetY + 12)
		end
	end
end

local function SetupClassIcon(Virtual)
	if Virtual.classIcon then return end
	Virtual.classIcon = Virtual.healthBar:CreateTexture(nil, "ARTWORK")
	Virtual.classIcon:Hide()
	UpdateClassIcon(Virtual)
end

local function UpdateEliteIcon(eliteIcon)
	eliteIcon:SetVertexColor(unpack(KP.dbp.eliteIcon_Tint))
	eliteIcon:ClearAllPoints()
	if KP.dbp.eliteIcon_anchor == "LEFT" then
		eliteIcon:SetTexCoord(0.578125, 0, 0.578125, 0.84375, 0, 0, 0, 0.84375)
		eliteIcon:SetPoint(KP.dbp.eliteIcon_anchor, KP.dbp.globalOffsetX, KP.dbp.globalOffsetY - 11.5)
	else
		if KP.dbp.healthBar_border == "KhalPlates" then
			eliteIcon:SetTexCoord(0, 0, 0, 0.84375, 0.578125, 0, 0.578125, 0.84375)
			eliteIcon:SetPoint(KP.dbp.eliteIcon_anchor, KP.dbp.globalOffsetX, KP.dbp.globalOffsetY - 11.5)
		else
			eliteIcon:SetTexCoord(0, 0, 0, 0.84375, 0.578125, 0, 0.578125, 0.84375)
			eliteIcon:SetPoint(KP.dbp.eliteIcon_anchor, KP.dbp.globalOffsetX + 24, KP.dbp.globalOffsetY - 11.5)
		end
	end
end

local function UpdateRaidTargetIcon(Virtual)
	local raidTargetIcon = Virtual.raidTargetIcon
	raidTargetIcon:SetSize(KP.dbp.raidTargetIcon_size, KP.dbp.raidTargetIcon_size)
	raidTargetIcon:ClearAllPoints()
	if KP.dbp.healthBar_border == "KhalPlates" then
		if KP.dbp.raidTargetIcon_anchor == "Left" then
			raidTargetIcon:SetPoint("RIGHT", Virtual, "LEFT",  KP.dbp.raidTargetIcon_offsetX + 11.5, KP.dbp.raidTargetIcon_offsetY + 11.5)
		elseif KP.dbp.raidTargetIcon_anchor == "Top" then
			raidTargetIcon:SetPoint("BOTTOM", Virtual, "TOP", KP.dbp.raidTargetIcon_offsetX, KP.dbp.raidTargetIcon_offsetY + 2)
		else
			raidTargetIcon:SetPoint("LEFT", Virtual, "RIGHT",  KP.dbp.raidTargetIcon_offsetX - 11.5, KP.dbp.raidTargetIcon_offsetY + 11.5)
		end
	else
		if KP.dbp.raidTargetIcon_anchor == "Left" then
			raidTargetIcon:SetPoint("RIGHT", Virtual, "LEFT", KP.dbp.raidTargetIcon_offsetX + 2, KP.dbp.raidTargetIcon_offsetY + 12)
		elseif KP.dbp.raidTargetIcon_anchor == "Top" then
			raidTargetIcon:SetPoint("BOTTOM", Virtual, "TOP", KP.dbp.raidTargetIcon_offsetX, KP.dbp.raidTargetIcon_offsetY + 16)
		else
			raidTargetIcon:SetPoint("LEFT", Virtual, "RIGHT", KP.dbp.raidTargetIcon_offsetX - 2, KP.dbp.raidTargetIcon_offsetY + 12)
		end
	end
end

local function UpdateBossIcon(Virtual)
	local bossIcon = Virtual.bossIcon
	bossIcon:ClearAllPoints()
	bossIcon:SetSize(KP.dbp.bossIcon_size, KP.dbp.bossIcon_size)
	if KP.dbp.healthBar_border == "KhalPlates" then
		if KP.dbp.bossIcon_anchor == "Left" then
			bossIcon:SetPoint("RIGHT", Virtual, "LEFT",  KP.dbp.bossIcon_offsetX + 15, KP.dbp.bossIcon_offsetY + 11.5)
		elseif KP.dbp.bossIcon_anchor == "Center" then
			bossIcon:SetPoint("CENTER", Virtual, "CENTER", KP.dbp.bossIcon_offsetX, KP.dbp.bossIcon_offsetY + 11.5)
		else
			bossIcon:SetPoint("LEFT", Virtual, "RIGHT",  KP.dbp.bossIcon_offsetX - 14, KP.dbp.bossIcon_offsetY + 11.5)
		end
	else
		if KP.dbp.bossIcon_anchor == "Left" then
			bossIcon:SetPoint("RIGHT", Virtual, "LEFT", KP.dbp.bossIcon_offsetX + 4.5, KP.dbp.bossIcon_offsetY + 11)
		elseif KP.dbp.bossIcon_anchor == "Center" then
			bossIcon:SetPoint("CENTER", Virtual, "CENTER", KP.dbp.bossIcon_offsetX, KP.dbp.bossIcon_offsetY + 11)
		else
			bossIcon:SetPoint("LEFT", Virtual, "RIGHT", KP.dbp.bossIcon_offsetX - 22.5, KP.dbp.bossIcon_offsetY + 11)
		end
	end
end

local function SetupKhalPlate(Virtual)
	local threatGlow, healthBarBorder, castBarBorder, shieldCastBarBorder, spellIcon, healthBarHighlight, nameText, levelText, bossIcon, raidTargetIcon, eliteIcon = Virtual:GetRegions()
	Virtual.threatGlow = threatGlow
	Virtual.castBarBorder = castBarBorder
	Virtual.shieldCastBarBorder = shieldCastBarBorder
	Virtual.healthBarHighlight = healthBarHighlight
	Virtual.nameText = nameText
	Virtual.levelText = levelText
	Virtual.bossIcon = bossIcon
	Virtual.raidTargetIcon = raidTargetIcon
	Virtual.eliteIcon = eliteIcon
	Virtual.healthBar, Virtual.castBar = Virtual:GetChildren()
	Virtual.healthBar.barTex = Virtual.healthBar:GetRegions()
	Virtual.castBar.barTex = Virtual.castBar:GetRegions()
	SetupHealthBorder(Virtual.healthBar)
	SetupNameText(Virtual.healthBar)
	SetupTargetGlow(Virtual)
	SetupHealthText(Virtual.healthBar)
	SetupBarBackground(Virtual.healthBar)
	SetupBarBackground(Virtual.castBar)
	SetupCastText(Virtual.castBar)
	SetupCastTimer(Virtual.castBar)
	SetupClassIcon(Virtual)
	UpdateBossIcon(Virtual)
	UpdateRaidTargetIcon(Virtual)
	UpdateEliteIcon(eliteIcon)
	healthBarBorder:Hide()
	nameText:Hide()
	levelText:SetFont(LSM:Fetch("font", KP.dbp.levelText_font), KP.dbp.levelText_size, KP.dbp.levelText_outline)
	castBarBorder:SetTexture(ASSETS .. "CastBar-Border")
	if KP.dbp.healthBar_border == "KhalPlates" then
		threatGlow:SetTexture(ASSETS .. "HealthBar-ThreatGlow")
		healthBarHighlight:SetTexture(ASSETS .. "HealthBar-MouseoverGlow")
		healthBarHighlight:SetSize(KP.NP_WIDTH, KP.NP_HEIGHT)
	else
		threatGlow:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
		healthBarHighlight:SetTexture(ASSETS .. "HealthBar-MouseoverGlowBlizz")
		healthBarHighlight:SetSize(KP.NP_WIDTH * 1.165, KP.NP_HEIGHT)
	end
	healthBarHighlight:SetVertexColor(unpack(KP.dbp.mouseoverGlow_Tint))
	Virtual.healthBar.barTex:SetDrawLayer("BORDER")
	if ClassByPlateColor(Virtual.healthBar) then
		Virtual.healthBar.barTex:SetTexture(LSM:Fetch("statusbar", KP.dbp.healthBar_playerTex))
	else
		Virtual.healthBar.barTex:SetTexture(LSM:Fetch("statusbar", KP.dbp.healthBar_npcTex))
	end
	Virtual.castBar.barTex:SetDrawLayer("BORDER")
	Virtual.castBar.barTex:SetTexture(LSM:Fetch("statusbar", KP.dbp.castBar_Tex))
	local function VirtualOnShow()
		healthBarHighlight:ClearAllPoints()
		if KP.dbp.healthBar_border == "KhalPlates" then
			castBarBorder:SetPoint("CENTER", KP.dbp.globalOffsetX, KP.dbp.globalOffsetY -19)
			castBarBorder:SetWidth(145)
			shieldCastBarBorder:SetWidth(145)
			healthBarHighlight:SetPoint("CENTER", 1.2 + KP.dbp.globalOffsetX, -8.7 + KP.dbp.globalOffsetY)
			if KP.dbp.levelText_hide then
				levelText:Hide()
			else
				levelText:ClearAllPoints()
				if KP.dbp.levelText_anchor == "Left" then
					levelText:SetPoint("CENTER", Virtual.healthBar, "LEFT", KP.dbp.levelText_offsetX - 10 , KP.dbp.levelText_offsetY + 0.3)
				elseif KP.dbp.levelText_anchor == "Center" then
					levelText:SetPoint("CENTER", Virtual.healthBar, "CENTER", KP.dbp.levelText_offsetX, KP.dbp.levelText_offsetY + 0.3)
				else
					levelText:SetPoint("CENTER", Virtual.healthBar, "RIGHT", KP.dbp.levelText_offsetX + 10, KP.dbp.levelText_offsetY + 0.3)
				end
			end
		else
			castBarBorder:SetPoint("CENTER", KP.dbp.globalOffsetX + 10.3, KP.dbp.globalOffsetY -19)
			castBarBorder:SetWidth(157)
			shieldCastBarBorder:SetWidth(157)
			healthBarHighlight:SetPoint("CENTER", 11.83 + KP.dbp.globalOffsetX, -8.7 + KP.dbp.globalOffsetY)
			if KP.dbp.levelText_hide then
				levelText:Hide()
			else
				levelText:ClearAllPoints()
				if KP.dbp.levelText_anchor == "Left" then
					levelText:SetPoint("CENTER", Virtual.healthBar, "LEFT", KP.dbp.levelText_offsetX - 13.5, KP.dbp.levelText_offsetY + 0.3)
				elseif KP.dbp.levelText_anchor == "Center" then
					levelText:SetPoint("CENTER", Virtual.healthBar, "CENTER", KP.dbp.levelText_offsetX + 11, KP.dbp.levelText_offsetY + 0.3)
				else
					levelText:SetPoint("CENTER", Virtual.healthBar, "RIGHT", KP.dbp.levelText_offsetX + 11.2, KP.dbp.levelText_offsetY + 0.3)
				end
			end
		end
		Virtual.healthBar.nameText:SetText(nameText:GetText())
		UpdateTargetGlow(Virtual)
	end
	VirtualOnShow()
	Virtual:HookScript("OnShow", VirtualOnShow)
end

local function SetupTotemPlate(Plate)
	if Plate.totemPlate then return end
	Plate.totemPlate = CreateFrame("Frame", nil, Plate)
	Plate.totemPlate:SetPoint("TOP", 0, KP.dbp.totemOffset - 5)
	Plate.totemPlate:SetSize(KP.dbp.totemSize, KP.dbp.totemSize)
	Plate.totemPlate:SetScale(KP.dbp.globalScale)
	Plate.totemPlate:Hide()
	Plate.totemPlate.icon = Plate.totemPlate:CreateTexture(nil, "ARTWORK")
	Plate.totemPlate.icon:SetAllPoints(Plate.totemPlate)
	Plate.totemPlate.targetGlow = Plate.totemPlate:CreateTexture(nil, "OVERLAY")
	Plate.totemPlate.targetGlow:SetSize(128*KP.dbp.totemSize/88, 128*KP.dbp.totemSize/88)
	Plate.totemPlate.targetGlow:SetTexture(ASSETS .. "TotemPlate-TargetGlow.blp")
	Plate.totemPlate.targetGlow:SetVertexColor(unpack(KP.dbp.targetGlow_Tint))
	Plate.totemPlate.targetGlow:SetPoint("CENTER")
	Plate.totemPlate.targetGlow:Hide()
end

function KP:UpdateAllVirtualsScale()
	for Plate, Virtual in pairs(VirtualPlates) do
		Virtual:SetScale(KP.dbp.globalScale)
		if Plate.totemPlate then
			Plate.totemPlate:SetScale(KP.dbp.globalScale)
		end
		if not KP.inCombat then
			if Virtual:IsShown() then
				if KP.dbp.healthBar_border == "KhalPlates" then
					Plate:SetSize(NP_WIDTH * KP.dbp.globalScale * 0.9, NP_HEIGHT * KP.dbp.globalScale * 0.7)
				else
					Plate:SetSize(NP_WIDTH * KP.dbp.globalScale, NP_HEIGHT * KP.dbp.globalScale)
				end
			else
				Plate:SetSize(0.01, 0.01)
			end
		end
	end
end

function KP:MoveAllVisiblePlates(diffX, diffY)
	for Plate, Virtual in pairs(PlatesVisible) do
		for _, Region in ipairs(Plate) do
			for i = 1, Region:GetNumPoints() do
				local point, relFrame, relPoint, xOfs, yOfs = Region:GetPoint(i)
                if relFrame == Virtual then
                    Region:SetPoint(point, Virtual, relPoint, xOfs + diffX, yOfs + diffY)
                end
			end
		end
	end
end

function KP:UpdateLevelFilter()
	for _, Virtual in pairs(VirtualPlates) do
		local name = Virtual.nameText:GetText()
		local totemTex = KP.TotemTexs[name]
		if totemTex then
			Virtual:Hide()
		else
			local level = tonumber(Virtual.levelText:GetText())
			if level and level < KP.dbp.levelFilter then
				Virtual:Hide()
			else
				Virtual:Show()
			end
		end
	end
end

function KP:UpdateAllHealthBars()
	for _, Virtual in pairs(VirtualPlates) do
		local healthBar = Virtual.healthBar
		local healthBarBorder = healthBar.healthBarBorder
		local healthText = healthBar.healthText
		if KP.dbp.healthBar_border == "KhalPlates" then
			healthBarBorder:SetTexture(ASSETS .. "HealthBar-Border")
		else
			healthBarBorder:SetTexture("Interface\\Tooltips\\Nameplate-Border")
		end
		healthBarBorder:SetVertexColor(unpack(KP.dbp.healthBar_borderTint))
		if ClassByPlateColor(healthBar) then
			healthBar.barTex:SetTexture(LSM:Fetch("statusbar", KP.dbp.healthBar_playerTex))
		else
			healthBar.barTex:SetTexture(LSM:Fetch("statusbar", KP.dbp.healthBar_npcTex))
		end
		if KP.dbp.healthText_hide then
			healthText:Hide()
		else
			healthText:Show()
			healthText:SetFont(LSM:Fetch("font", KP.dbp.healthText_font), KP.dbp.healthText_size, KP.dbp.healthText_outline)
			healthText:ClearAllPoints()
			healthText:SetPoint(KP.dbp.healthText_anchor, KP.dbp.healthText_offsetX, KP.dbp.healthText_offsetY + 0.3)
			healthText:SetTextColor(unpack(KP.dbp.healthText_color))
		end
	end
end

function KP:UpdateAllNameTexts()
	for _, Virtual in pairs(VirtualPlates) do
		local nameText = Virtual.healthBar.nameText
		if KP.dbp.nameText_hide then
			nameText:Hide()
		else
			nameText:Show()
			nameText:SetFont(LSM:Fetch("font", KP.dbp.nameText_font), KP.dbp.nameText_size, KP.dbp.nameText_outline)
			nameText:ClearAllPoints()
			nameText:SetPoint(KP.dbp.nameText_anchor, KP.dbp.nameText_offsetX + 0.2, KP.dbp.nameText_offsetY + 0.7)
			nameText:SetWidth(KP.dbp.nameText_width)
			nameText:SetJustifyH(KP.dbp.nameText_anchor)
			nameText:SetTextColor(unpack(KP.dbp.nameText_color))
		end
	end
end

function KP:UpdateAllLevelTexts()
	for _, Virtual in pairs(VirtualPlates) do
		local levelText = Virtual.levelText
		if KP.dbp.levelText_hide then
			levelText:Hide()
		else
			levelText:SetFont(LSM:Fetch("font", KP.dbp.levelText_font), KP.dbp.levelText_size, KP.dbp.levelText_outline)
			levelText:ClearAllPoints()
			if KP.dbp.healthBar_border == "KhalPlates" then
				if KP.dbp.levelText_anchor == "Left" then
					levelText:SetPoint("CENTER", Virtual.healthBar, "LEFT", KP.dbp.levelText_offsetX - 10, KP.dbp.levelText_offsetY + 0.3)
				elseif KP.dbp.levelText_anchor == "Center" then
					levelText:SetPoint("CENTER", Virtual.healthBar, "CENTER", KP.dbp.levelText_offsetX, KP.dbp.levelText_offsetY + 0.3)
				else
					levelText:SetPoint("CENTER", Virtual.healthBar, "RIGHT", KP.dbp.levelText_offsetX + 10, KP.dbp.levelText_offsetY + 0.3)
				end
			else
				if KP.dbp.levelText_anchor == "Left" then
					levelText:SetPoint("CENTER", Virtual.healthBar, "LEFT", KP.dbp.levelText_offsetX - 13.5, KP.dbp.levelText_offsetY + 0.3)
				elseif KP.dbp.levelText_anchor == "Center" then
					levelText:SetPoint("CENTER", Virtual.healthBar, "CENTER", KP.dbp.levelText_offsetX + 11, KP.dbp.levelText_offsetY + 0.3)
				else
					levelText:SetPoint("CENTER", Virtual.healthBar, "RIGHT", KP.dbp.levelText_offsetX + 11.2, KP.dbp.levelText_offsetY + 0.3)
				end
			end
			levelText:Show()
		end
	end
end

function KP:UpdateAllCastBarBorders()
	for _, Virtual in pairs(VirtualPlates) do
		local castBarBorder = Virtual.castBarBorder
		local shieldCastBarBorder = Virtual.shieldCastBarBorder
		if KP.dbp.healthBar_border == "KhalPlates" then
			castBarBorder:SetPoint("CENTER", KP.dbp.globalOffsetX, KP.dbp.globalOffsetY -19)
			castBarBorder:SetWidth(145)
			shieldCastBarBorder:SetWidth(145)
		else
			castBarBorder:SetPoint("CENTER", KP.dbp.globalOffsetX + 10.5, KP.dbp.globalOffsetY -19)
			castBarBorder:SetWidth(157)
			shieldCastBarBorder:SetWidth(157)
		end
	end
end

function KP:UpdateAllCastBars()
	for _, Virtual in pairs(VirtualPlates) do
		local castBar = Virtual.castBar
		local castText = castBar.castText
		local castTimerText = castBar.castTimerText
		castBar.barTex:SetTexture(LSM:Fetch("statusbar", KP.dbp.castBar_Tex))
		if KP.dbp.castText_hide then
			castText:Hide()
		else
			castText:Show()
			castText:SetFont(LSM:Fetch("font", KP.dbp.castText_font), KP.dbp.castText_size, KP.dbp.castText_outline)
			castText:SetTextColor(unpack(KP.dbp.castText_color))
			castText:SetJustifyH(KP.dbp.castText_anchor)
			castText:SetWidth(KP.dbp.castText_width)
			castText:ClearAllPoints()
			if KP.dbp.healthBar_border == "KhalPlates" then
				castText:SetPoint(KP.dbp.castText_anchor, KP.dbp.castText_offsetX - 3.8, KP.dbp.castText_offsetY + 1.6)
			else
				castText:SetPoint(KP.dbp.castText_anchor, KP.dbp.castText_offsetX - 9.3, KP.dbp.castText_offsetY + 1.6)
			end
		end
		if KP.dbp.castTimerText_hide then
			castTimerText:Hide()
		else
			castTimerText:Show()
			castTimerText:SetFont(LSM:Fetch("font", KP.dbp.castTimerText_font), KP.dbp.castTimerText_size, KP.dbp.castTimerText_outline)
			castTimerText:SetTextColor(unpack(KP.dbp.castTimerText_color))
			castTimerText:ClearAllPoints()
			castTimerText:SetPoint(KP.dbp.castTimerText_anchor, KP.dbp.castTimerText_offsetX - 2, KP.dbp.castTimerText_offsetY + 1)
		end
	end
end

function KP:UpdateAllGlows()
	for Plate, Virtual in pairs(VirtualPlates) do
		local targetGlow = Virtual.healthBar.targetGlow
		local targetGlowTotem = Plate.totemPlate and Plate.totemPlate.targetGlow
		local healthBarHighlight = Virtual.healthBarHighlight
		local threatGlow = Virtual.threatGlow
		targetGlow:SetVertexColor(unpack(KP.dbp.targetGlow_Tint))
		healthBarHighlight:SetVertexColor(unpack(KP.dbp.mouseoverGlow_Tint))
		healthBarHighlight:ClearAllPoints()
		if KP.dbp.healthBar_border == "KhalPlates" then
			targetGlow:SetTexture(ASSETS .. "HealthBar-TargetGlow")
			targetGlow:SetSize(KP.NP_WIDTH, KP.NP_HEIGHT)
			targetGlow:SetPoint("CENTER", 0.7, 0.5)
			healthBarHighlight:SetTexture(ASSETS .. "HealthBar-MouseoverGlow")
			healthBarHighlight:SetSize(KP.NP_WIDTH, KP.NP_HEIGHT)
			healthBarHighlight:SetPoint("CENTER", 1.2 + KP.dbp.globalOffsetX, -8.7 + KP.dbp.globalOffsetY)
			threatGlow:SetTexture(ASSETS .. "HealthBar-ThreatGlow")
		else
			targetGlow:SetTexture(ASSETS .. "HealthBar-TargetGlowBlizz")
			targetGlow:SetSize(KP.NP_WIDTH * 1.165, KP.NP_HEIGHT)
			targetGlow:SetPoint("CENTER", 11.33, 0.5)
			healthBarHighlight:SetTexture(ASSETS .. "HealthBar-MouseoverGlowBlizz")
			healthBarHighlight:SetSize(KP.NP_WIDTH * 1.165, KP.NP_HEIGHT)
			healthBarHighlight:SetPoint("CENTER", 11.83 + KP.dbp.globalOffsetX, -8.7 + KP.dbp.globalOffsetY)
			threatGlow:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
		end
		if targetGlowTotem then
			targetGlowTotem:SetVertexColor(unpack(KP.dbp.targetGlow_Tint))
		end
	end
end

function KP:UpdateAllThreatGlows()
	for _, Virtual in pairs(VirtualPlates) do
		if KP.dbp.healthBar_border == "KhalPlates" then
			Virtual.threatGlow:SetTexture(ASSETS .. "HealthBar-ThreatGlow")
		else
			Virtual.threatGlow:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
		end
	end
end

function KP:UpdateAllIcons()
	for _, Virtual in pairs(VirtualPlates) do
		UpdateBossIcon(Virtual)
		UpdateRaidTargetIcon(Virtual)
		UpdateEliteIcon(Virtual.eliteIcon)
		UpdateClassIcon(Virtual)
	end
end

function KP:UpdateAllClassIcons()
	for Plate, Virtual in pairs(PlatesVisible) do
		local name = Virtual.nameText:GetText()
		Virtual.classIcon:Hide()
		if not KP.TotemTexs[name] and KP.inPvPInstance then
			local class = ClassByPlateColor(Virtual.healthBar)
			if class then
				if class == "FRIENDLY" and KP.dbp.showClassOnFriends then
					class = KP.ClassByFriendName[name] or ""
					Virtual.classIcon:SetTexture(ASSETS .. "Classes\\" .. class)
					Virtual.classIcon:Show()
				elseif class ~= "FRIENDLY" and KP.dbp.showClassOnEnemies then
					Virtual.classIcon:SetTexture(ASSETS .. "Classes\\" .. class)
					Virtual.classIcon:Show()
				end
			end
		end
	end
end

function KP:UpdateAllTotemPlates()
	for Plate in pairs(VirtualPlates) do
		local totemPlate = Plate.totemPlate
		if totemPlate then
			totemPlate:SetPoint("TOP", 0, KP.dbp.totemOffset - 5)
			totemPlate:SetSize(KP.dbp.totemSize, KP.dbp.totemSize)
			totemPlate.targetGlow:SetSize(128*KP.dbp.totemSize/88, 128*KP.dbp.totemSize/88)
		end
	end
end

function KP:UpdateProfile()
	self:UpdateAllVirtualsScale()
	self:UpdateLevelFilter()
	self:UpdateAllHealthBars()
	self:UpdateAllNameTexts()
	self:UpdateAllLevelTexts()
	self:UpdateAllCastBarBorders()
	self:UpdateAllCastBars()
	self:UpdateAllGlows()
	self:UpdateAllIcons()
	self:UpdateAllClassIcons()
	self:UpdateAllTotemPlates()
end

----------- Reference for KhalPlates.lua -----------
KP.LSM = LSM
KP.VirtualPlates = VirtualPlates
KP.RealPlates = RealPlates
KP.PlatesVisible = PlatesVisible
KP.NP_WIDTH = NP_WIDTH
KP.NP_HEIGHT = NP_HEIGHT
KP.ASSETS = ASSETS
KP.UpdateTargetGlow = UpdateTargetGlow
KP.ClassByPlateColor = ClassByPlateColor
KP.SetupKhalPlate = SetupKhalPlate
KP.SetupTotemPlate = SetupTotemPlate