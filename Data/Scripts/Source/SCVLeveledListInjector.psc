ScriptName SCVLeveledListInjector Extends Quest
{Stuff that needs to be inserted at the start}

Event OnInit()
  SCLibrary.addToReloadList(Self)
  Maintenence()
EndEvent

Int Function GetStage()
  Maintenence()
  Return Parent.GetStage()
EndFunction

Function Maintenence()
  _CheckVersion()
EndFunction

Int ScriptVersion = 1
Function _CheckVersion()
  Int StoredVersion = JDB.solveInt(".SCLExtraData.VersionRecords.SCVLeveledList")
  If ScriptVersion >= 1 && StoredVersion < 1
    ;Prey Items
    LItemSpellTomes00Illusion.AddForm(SCV_SpellTomeHungerFury, 1, 1)
    LItemSpellTomes00AllIllusion.AddForm(SCV_SpellTomeHungerFury, 1, 1)
    LItemSpellTomes00Spells.AddForm(SCV_SpellTomeHungerFury, 1, 1)
    LItemSpellTomes00AllSpells.AddForm(SCV_SpellTomeHungerFury, 1, 1)

    LItemSpellTomes50Illusion.AddForm(SCV_SpellTomeHungerFrenzy, 1, 1)
    LItemSpellTomes50AllIllusion.AddForm(SCV_SpellTomeHungerFrenzy, 1, 1)
    LItemSpellTomes50Spells.AddForm(SCV_SpellTomeHungerFrenzy, 1, 1)

    SublistEnchArmorElvenCuirass03.AddForm(SCV_EnchArmorElvenCuirassCorneredRat03, 1, 1)

    SublistEnchArmorGlassCuirass05.AddForm(SCV_EnchArmorGlassCuirassCorneredRat05, 1, 1)

    SublistEnchArmorScaledCuirass02.AddForm(SCV_EnchArmorScaledCuirassCorneredRat02, 1, 1)

    LItemEnchNecklaceAll.AddForm(SCV_LItemEnchNecklacePushback, 1, 1)

    LItemEnchNecklaceAll25.AddForm(SCV_LItemEnchNecklacePushback, 1, 1)

    LItemEnchCircletAll.AddForm(SCV_LItemEnchCircletThrillingStruggle, 1, 1)

    LItemEnchCircletAll25.AddForm(SCV_LItemEnchCircletThrillingStruggle, 1, 1)

    LItemEnchCircletAll75.AddForm(SCV_LItemEnchCircletThrillingStruggle, 1, 1)


  EndIf

  If ScriptVersion >= 2 && StoredVersion < 2
    ;Stuff Here
  EndIf
  JDB.solveIntSetter(".SCLExtraData.VersionRecords.SCVLeveledList", ScriptVersion, True)
EndFunction

Armor Property SCV_EnchArmorDaedricCuirassCorneredRat06 Auto
LeveledItem Property SublistEnchArmorDaedricCuirass06 Auto

Armor Property SCV_EnchArmorGlassCuirassCorneredRat05 Auto
LeveledItem Property SublistEnchArmorGlassCuirass05 Auto

Armor Property SCV_EnchArmorElvenCuirassCorneredRat03 Auto
LeveledItem Property SublistEnchArmorElvenCuirass03 Auto

Armor Property SCV_EnchArmorOrcishCuirassCorneredRat04 Auto
LeveledItem Property SublistEnchArmorOrcishCuirass04 Auto

Armor Property SCV_EnchArmorScaledCuirassCorneredRat02 Auto
LeveledItem Property SublistEnchArmorScaledCuirass02 Auto

LeveledItem Property SCV_LItemEnchNecklacePushback Auto
LeveledItem Property LItemEnchNecklaceAll Auto
LeveledItem Property LItemEnchNecklaceAll25 Auto

LeveledItem Property SCV_LItemEnchCircletThrillingStruggle Auto
LeveledItem Property LItemEnchCircletAll Auto
LeveledItem Property LItemEnchCircletAll25 Auto
LeveledItem Property LItemEnchCircletAll75 Auto

Book Property SCV_SpellTomeHungerFury Auto
LeveledItem Property LItemSpellTomes00Illusion Auto
LeveledItem Property LItemSpellTomes00AllIllusion Auto
LeveledItem Property LItemSpellTomes00Spells Auto
LeveledItem Property LItemSpellTomes00AllSpells Auto

Book Property SCV_SpellTomeHungerFrenzy Auto
LeveledItem Property LItemSpellTomes50Illusion Auto
LeveledItem Property LItemSpellTomes50AllIllusion Auto
LeveledItem Property LItemSpellTomes50Spells Auto
