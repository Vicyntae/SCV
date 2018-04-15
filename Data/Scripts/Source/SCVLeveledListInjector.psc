ScriptName SCVLeveledListInjector Extends Quest

LeveledItem Property LItemSpellTomes00Illusion Auto
LeveledItem Property LItemSpellTomes00AllIllusion Auto
LeveledItem Property LItemSpellTomes00Spells Auto
LeveledItem Property LItemSpellTomes00AllSpells Auto

LeveledItem Property LItemSpellTomes50Conjuration Auto
LeveledItem Property LItemSpellTomes50AllConjuration Auto
LeveledItem Property LItemSpellTomes50Illusion Auto
LeveledItem Property LItemSpellTomes50AllIllusion Auto
LeveledItem Property LItemSpellTomes50Spells Auto

LeveledItem Property LItemSpellTomes75Conjuration Auto
LeveledItem Property LItemSpellTomes75AllConjuration Auto
LeveledItem Property LItemSpellTomes75Spells Auto

Book Property SCV_SpellTomeRemoteSwallow Auto
Book Property SCV_SpellTomeMassSwallow Auto
Book Property SCV_SpellTomeHungerFury Auto
Book Property SCV_SpellTomeHungerFrenzy Auto

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
  Int StoredVersion = JDB.solveInt(".SCLExtraData.VersionRecords.SCVLeveledLists")
  If ScriptVersion >= 1 && StoredVersion < 1
    LItemSpellTomes00Illusion.AddForm(SCV_SpellTomeHungerFury, 1, 1)
    LItemSpellTomes00AllIllusion.AddForm(SCV_SpellTomeHungerFury, 1, 1)
    LItemSpellTomes00Spells.AddForm(SCV_SpellTomeHungerFury, 1, 1)
    LItemSpellTomes00AllSpells.AddForm(SCV_SpellTomeHungerFury, 1, 1)

    LItemSpellTomes50Conjuration.AddForm(SCV_SpellTomeRemoteSwallow, 1, 1)
    LItemSpellTomes50AllConjuration.AddForm(SCV_SpellTomeRemoteSwallow, 1, 1)
    LItemSpellTomes50Spells.AddForm(SCV_SpellTomeRemoteSwallow, 1, 1)

    LItemSpellTomes50Illusion.AddForm(SCV_SpellTomeHungerFrenzy, 1, 1)
    LItemSpellTomes50AllIllusion.AddForm(SCV_SpellTomeHungerFrenzy, 1, 1)
    LItemSpellTomes50Spells.AddForm(SCV_SpellTomeHungerFrenzy, 1, 1)

    LItemSpellTomes75Conjuration.AddForm(SCV_SpellTomeMassSwallow, 1, 1)
    LItemSpellTomes75AllConjuration.AddForm(SCV_SpellTomeMassSwallow, 1, 1)
    LItemSpellTomes75Spells.AddForm(SCV_SpellTomeMassSwallow, 1, 1)

  EndIf

  If ScriptVersion >= 2 && StoredVersion < 2
    ;Stuff Here
  EndIf
  JDB.solveIntSetter(".SCLExtraData.VersionRecords.SCVLeveledLists", ScriptVersion, True)
EndFunction
