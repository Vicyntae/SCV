ScriptName SCVLeveledListInjectorPlayerPred Extends ActiveMagicEffect
{Stuff to be inserted when the player becomes any type of pred.}
Event OnPlayerLoadGame()
  Maintenence()
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Maintenence()
EndEvent

Int ScriptVersion = 1
Function Maintenence()
  Int StoredVersion = JDB.solveInt(".SCLExtraData.VersionRecords.SCVLeveledListPlayerPred")

  If ScriptVersion >= 1 && StoredVersion < 1
    SublistEnchARmorDaedricGauntlets06.AddForm(SCV_EnchArmorDaedricGauntletsIntenseHunger05, 1, 1)
    SublistEnchArmorDaedricCuirass05.AddForm(SCV_EnchArmorDaedricCuirassPitOfSouls05, 1, 1)
    SublistEnchArmorDragonplateGauntlets06.AddForm(SCV_EnchArmorDragonplateGauntletsExpiredEpicurian06, 1, 1)
    SublistEnchArmorDragonplateGauntlets06.AddForm(SCV_EnchArmorDragonplateGauntletsIntenseHunger06, 1, 1)
    SublistEnchArmorDragonscaleBoots06.AddForm(SCV_EnchArmorDragonscaleBootsStalker06, 1, 1)
    SublistEnchArmorDragonscaleCuirass06.AddForm(SCV_EnchArmorDragonscaleCuirassPitOfSouls06, 1, 1)
    SublistEnchArmorDragonscaleGauntlets06.AddForm(SCV_EnchArmorDragonscaleGauntletsFollowerNamira06, 1, 1)
    SublistEnchArmorDragonscaleGauntlets05.AddForm(SCV_EnchArmorDragonscaleGauntletsIntenseHunger05, 1, 1)
    SublistEnchArmorDwarvenGauntlets02.AddForm(SCV_EnchArmorDwarvenGauntletsFollowerNamira02, 1, 1)
    SublistEnchArmorDwarvenGauntlets02.AddForm(SCV_EnchArmorDwarvenGauntletsMetalMuncher01, 1, 1)
    SublistEnchArmorDwarvenBoots04.AddForm(SCV_EnchArmorDwarvenBootsMetalMuncher04, 1, 1)
    SublistEnchArmorDwarvenCuirass02.AddForm(SCV_EnchArmorDwarvenCuirassMetalMuncher02, 1, 1)
    SublistEnchArmorDwarvenCuirass04.AddForm(SCV_EnchArmorDwarvenCuirassMetalMuncher06, 1, 1)
    SublistEnchArmorDwarvenGauntlets04.AddForm(SCV_EnchArmorDwarvenGauntletsMetalMuncher05, 1, 1)
    SublistEnchArmorDwarvenHelmet03.AddForm(SCV_EnchArmorDwarvenHelmetMetalMuncher03, 1, 1)
    SublistEnchArmorEbonyGauntlets05.AddForm(SCV_EnchArmorEbonyGauntletsFollowerNamira05, 1, 1)
    SublistEnchArmorElvenBoots03.AddForm(SCV_EnchArmorElvenBootsStalker03, 1, 1)
    SublistEnchArmorElvenBoots04.AddForm(SCV_EnchArmorElvenBootsStalker04, 1, 1)
    SublistEnchArmorElvenCuirass03.AddForm(SCV_EnchArmorElvenCuirassPitOfSouls03, 1, 1)
    SublistEnchArmorElvenGauntlets03.AddForm(SCV_EnchArmorElvenGauntletsExpiredEpicurian03, 1, 1)
    SublistEnchArmorElvenGauntlets03.AddForm(SCV_EnchArmorElvenGauntletsFollowerNamira03, 1, 1)
    SublistEnchArmorGlassBoots05.AddForm(SCV_EnchArmorGlassBootsStalker05, 1, 1)
    SublistEnchArmorGlassBoots05.AddForm(SCV_EnchArmorGlassBootsStalker06, 1, 1)
    SublistEnchArmorGlassCuirass04.AddForm(SCV_EnchArmorGlassCuirassPitOfSouls04, 1, 1)
    SublistEnchArmorGlassGauntlets05.AddForm(SCV_EnchArmorGlassGauntletsExpiredEpicurian05, 1, 1)
    SublistEnchArmorGlassGauntlets04.AddForm(SCV_EnchArmorGlassGauntletsIntenseHunger04, 1, 1)
    SublistEnchArmorHideGauntlets01.AddForm(SCV_EnchArmorHideGauntletsFollowerNamira01, 1, 1)
    SublistEnchArmorHideGauntlets01.AddForm(SCV_EnchArmorHideGauntletsIntenseHunger01, 1, 1)
    SublistEnchArmorHideGauntlets01.AddForm(SCV_EnchArmorImperialLightGauntletsIntenseHunger01, 1, 1)
    SublistEnchArmorHideGauntlets02.AddForm(SCV_EnchArmorImperialLightGauntletsIntenseHunger02, 1, 1)
    SublistEnchArmorIronGauntlets01.AddForm(SCV_EnchArmorIronGauntletsExpiredEpicurian01, 1, 1)
    SublistEnchArmorIronGauntlets01.AddForm(SCV_EnchArmorIronGauntletsIntenseHunger01, 1, 1)
    SublistEnchArmorLeatherBoots01.AddForm(SCV_EnchArmorLeatherBootsStalker01, 1, 1)
    SublistEnchArmorLeatherBoots02.AddForm(SCV_EnchArmorLeatherBootsStalker02, 1, 1)
    SublistEnchArmorLeatherCuirass01.AddForm(SCV_EnchArmorLeatherCuirassPitOfSouls01, 1, 1)
    SublistEnchArmorLeatherGauntlets01.AddForm(SCV_EnchArmorLeatherGauntletsIntenseHunger01, 1, 1)
    SublistEnchArmorOrcishCuirass04.AddForm(SCV_EnchArmorOrcishCuirassPitOfSouls04, 1, 1)
    SublistEnchArmorOrcishGauntlets04.AddForm(SCV_EnchArmorOrcishGauntletsExpiredEpicurian04, 1, 1)
    SublistEnchArmorOrcishGauntlets04.AddForm(SCV_EnchArmorOrcishGauntletsFollowerNamira04, 1, 1)
    SublistEnchArmorOrcishGauntlets03.AddForm(SCV_EnchArmorOrcishGauntletsIntenseHunger03, 1, 1)
    SublistEnchArmorScaledCuirass02.AddForm(SCV_EnchArmorScaledCuirassPitOfSouls02, 1, 1)
    SublistEnchArmorScaledGauntlets02.AddForm(SCV_EnchArmorScaledGauntletsExpiredEpicurian02, 1, 1)
    SublistEnchArmorScaledGauntlets02.AddForm(SCV_EnchArmorScaledGauntletsIntenseHunger02, 1, 1)
    SublistEnchArmorSteelBoots02.AddForm(SCV_EnchArmorSteelBootsStalker02, 1, 1)
    SublistEnchArmorSteelPlateGauntlets03.AddForm(SCV_EnchArmorSteelPlateGauntletsIntenseHunger03, 1, 1)
    LItemEnchNecklaceAll.AddForm(SCV_LItemEnchNecklaceNourish, 1, 1)
    LItemEnchNecklaceAll25.AddForm(SCV_LItemEnchNecklaceNourish, 1, 1)
    LItemEnchRingAll.AddForm(SCV_LItemEnchRingSkillVore, 1, 1)
    LItemEnchRingAll25.AddForm(SCV_LItemEnchRingSkillVore, 1, 1)
    LItemEnchRingAll75.AddForm(SCV_LItemEnchRingSkillVore, 1, 1)
  EndIf


  ;/If ScriptVersion >= 2 && StoredVersion < 2
  EndIf/;
  JDB.solveIntSetter(".SCLExtraData.VersionRecords.SCVLeveledListPlayerPred", ScriptVersion, True)
EndFunction


Armor Property SCV_EnchArmorDaedricCuirassPitOfSouls05 Auto
LeveledItem Property SublistEnchArmorDaedricCuirass05 Auto

Armor Property SCV_EnchArmorDaedricGauntletsIntenseHunger05 Auto
LeveledItem Property SublistEnchARmorDaedricGauntlets06 Auto

Armor Property SCV_EnchArmorDragonplateGauntletsExpiredEpicurian06 Auto
Armor Property SCV_EnchArmorDragonplateGauntletsIntenseHunger06 Auto
LeveledItem Property SublistEnchArmorDragonplateGauntlets06 Auto

Armor Property SCV_EnchArmorDragonscaleBootsStalker06 Auto
LeveledItem Property SublistEnchArmorDragonscaleBoots06 Auto

Armor Property SCV_EnchArmorDragonscaleCuirassPitOfSouls06 Auto
LeveledItem Property SublistEnchArmorDragonscaleCuirass06 Auto

Armor Property SCV_EnchArmorDragonscaleGauntletsFollowerNamira06 Auto
LeveledItem Property SublistEnchArmorDragonscaleGauntlets06 Auto

Armor Property SCV_EnchArmorDragonscaleGauntletsIntenseHunger05 Auto
LeveledItem Property SublistEnchArmorDragonscaleGauntlets05 Auto

Armor Property SCV_EnchArmorDwarvenGauntletsFollowerNamira02 Auto
Armor Property SCV_EnchArmorDwarvenGauntletsMetalMuncher01 Auto
LeveledItem Property SublistEnchArmorDwarvenGauntlets02 Auto

Armor Property SCV_EnchArmorDwarvenBootsMetalMuncher04 Auto
LeveledItem Property SublistEnchArmorDwarvenBoots04 Auto

Armor Property SCV_EnchArmorDwarvenCuirassMetalMuncher02 Auto
LeveledItem Property SublistEnchArmorDwarvenCuirass02 Auto

Armor Property SCV_EnchArmorDwarvenCuirassMetalMuncher06 Auto
LeveledItem Property SublistEnchArmorDwarvenCuirass04 Auto

Armor Property SCV_EnchArmorDwarvenGauntletsMetalMuncher05 Auto
LeveledItem Property SublistEnchArmorDwarvenGauntlets04 Auto

Armor Property SCV_EnchArmorDwarvenHelmetMetalMuncher03 Auto
LeveledItem Property SublistEnchArmorDwarvenHelmet03 Auto

Armor Property SCV_EnchArmorEbonyGauntletsFollowerNamira05 Auto
LeveledItem Property SublistEnchArmorEbonyGauntlets05 Auto

Armor Property SCV_EnchArmorElvenBootsStalker03 Auto
LeveledItem Property SublistEnchArmorElvenBoots03 Auto

Armor Property SCV_EnchArmorElvenBootsStalker04 Auto
LeveledItem Property SublistEnchArmorElvenBoots04 Auto

Armor Property SCV_EnchArmorElvenCuirassPitOfSouls03 Auto
LeveledItem Property SublistEnchArmorElvenCuirass03 Auto

Armor Property SCV_EnchArmorElvenGauntletsExpiredEpicurian03 Auto
Armor Property SCV_EnchArmorElvenGauntletsFollowerNamira03 Auto
LeveledItem Property SublistEnchArmorElvenGauntlets03 Auto

Armor Property SCV_EnchArmorGlassBootsStalker05 Auto
Armor Property SCV_EnchArmorGlassBootsStalker06 Auto
LeveledItem Property SublistEnchArmorGlassBoots05 Auto

Armor Property SCV_EnchArmorGlassCuirassPitOfSouls04 Auto
LeveledItem Property SublistEnchArmorGlassCuirass04 Auto

Armor Property SCV_EnchArmorGlassGauntletsExpiredEpicurian05 Auto
LeveledItem Property SublistEnchArmorGlassGauntlets05 Auto

Armor Property SCV_EnchArmorGlassGauntletsIntenseHunger04 Auto
LeveledItem Property SublistEnchArmorGlassGauntlets04 Auto

Armor Property SCV_EnchArmorHideGauntletsFollowerNamira01 Auto
Armor Property SCV_EnchArmorHideGauntletsIntenseHunger01 Auto
Armor Property SCV_EnchArmorImperialLightGauntletsIntenseHunger01 Auto
LeveledItem Property SublistEnchArmorHideGauntlets01 Auto

Armor Property SCV_EnchArmorImperialLightGauntletsIntenseHunger02 Auto
LeveledItem Property SublistEnchArmorHideGauntlets02 Auto

Armor Property SCV_EnchArmorIronGauntletsExpiredEpicurian01 Auto
Armor Property SCV_EnchArmorIronGauntletsIntenseHunger01 Auto
LeveledItem Property SublistEnchArmorIronGauntlets01 Auto

Armor Property SCV_EnchArmorLeatherBootsStalker01 Auto
LeveledItem Property SublistEnchArmorLeatherBoots01 Auto

Armor Property SCV_EnchArmorLeatherBootsStalker02 Auto
LeveledItem Property SublistEnchArmorLeatherBoots02 Auto

Armor Property SCV_EnchArmorLeatherCuirassPitOfSouls01 Auto
LeveledItem Property SublistEnchArmorLeatherCuirass01 Auto

Armor Property SCV_EnchArmorLeatherGauntletsIntenseHunger01 Auto
LeveledItem Property SublistEnchArmorLeatherGauntlets01 Auto

Armor Property SCV_EnchArmorOrcishCuirassPitOfSouls04 Auto
LeveledItem Property SublistEnchArmorOrcishCuirass04 Auto

Armor Property SCV_EnchArmorOrcishGauntletsExpiredEpicurian04 Auto
Armor Property SCV_EnchArmorOrcishGauntletsFollowerNamira04 Auto
LeveledItem Property SublistEnchArmorOrcishGauntlets04 Auto

Armor Property SCV_EnchArmorOrcishGauntletsIntenseHunger03 Auto
LeveledItem Property SublistEnchArmorOrcishGauntlets03 Auto

Armor Property SCV_EnchArmorScaledCuirassPitOfSouls02 Auto
LeveledItem Property SublistEnchArmorScaledCuirass02 Auto

Armor Property SCV_EnchArmorScaledGauntletsExpiredEpicurian02 Auto
Armor Property SCV_EnchArmorScaledGauntletsIntenseHunger02 Auto
LeveledItem Property SublistEnchArmorScaledGauntlets02 Auto

Armor Property SCV_EnchArmorSteelBootsStalker02 Auto
LeveledItem Property SublistEnchArmorSteelBoots02 Auto

Armor Property SCV_EnchArmorSteelPlateGauntletsIntenseHunger03 Auto
LeveledItem Property SublistEnchArmorSteelPlateGauntlets03 Auto

LeveledItem Property SCV_LItemEnchNecklaceNourish Auto
LeveledItem Property LItemEnchNecklaceAll Auto
LeveledItem Property LItemEnchNecklaceAll25 Auto

LeveledItem Property SCV_LItemEnchRingSkillVore Auto
LeveledItem Property LItemEnchRingAll Auto
LeveledItem Property LItemEnchRingAll25 Auto
LeveledItem Property LItemEnchRingAll75 Auto
