ScriptName SCVLeveledListInjectorPlayerOVPred Extends ActiveMagicEffect
{Stuff that's inserted when the player becomes an OV pred}
Event OnPlayerLoadGame()
  Maintenence()
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Maintenence()
EndEvent

Int ScriptVersion = 1
Function Maintenence()
  Int StoredVersion = JDB.solveInt(".SCLExtraData.VersionRecords.SCVLeveledListPlayerOVPred")

  If ScriptVersion >= 1 && StoredVersion < 1


    LItemSpellTomes50Conjuration.AddForm(SCV_SpellTomeRemoteSwallow, 1, 1)
    LItemSpellTomes50AllConjuration.AddForm(SCV_SpellTomeRemoteSwallow, 1, 1)
    LItemSpellTomes50Spells.AddForm(SCV_SpellTomeRemoteSwallow, 1, 1)



    LItemSpellTomes75Conjuration.AddForm(SCV_SpellTomeMassSwallow, 1, 1)
    LItemSpellTomes75AllConjuration.AddForm(SCV_SpellTomeMassSwallow, 1, 1)
    LItemSpellTomes75Spells.AddForm(SCV_SpellTomeMassSwallow, 1, 1)

  EndIf

  ;/If ScriptVersion >= 2 && StoredVersion < 2

  EndIf/;
  JDB.solveIntSetter(".SCLExtraData.VersionRecords.SCVLeveledListPlayerOVPred", ScriptVersion, True)
EndFunction

Book Property SCV_SpellTomeRemoteSwallow Auto
LeveledItem Property LItemSpellTomes50Conjuration Auto
LeveledItem Property LItemSpellTomes50AllConjuration Auto
LeveledItem Property LItemSpellTomes50Spells Auto

Book Property SCV_SpellTomeMassSwallow Auto
LeveledItem Property LItemSpellTomes75Conjuration Auto
LeveledItem Property LItemSpellTomes75AllConjuration Auto
LeveledItem Property LItemSpellTomes75Spells Auto
