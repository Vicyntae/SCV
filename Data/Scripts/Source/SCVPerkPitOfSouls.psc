ScriptName SCVPerkPitOfSouls Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Description = New String[4]
  Description[0] = "Enables one to capture enemy souls."
  Description[1] = "Enables one to capture enemy souls by storing soul gems in their stomach."
  Description[2] = "Soul gems can now capture souls one size bigger."
  Description[3] = "Soul gems can now capture souls two sizes bigger."

  Requirements = New String[4]
  Requirements[0] = "Enables one to capture enemy souls."
  Requirements[1] = "Enables one to capture enemy souls by storing soul gems in their stomach."
  Requirements[2] = "Soul gems can now capture souls one size bigger."
  Requirements[3] = "Soul gems can now capture souls two sizes bigger."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  Int Enchant = akTarget.GetActorValue("Enchanting") as Int
  Int SpiritLevel = SCVLib.getCurrentPerkLevel(akTarget, "SCV_SpiritSwallower")
  Int Level = akTarget.GetLevel()
  Int NumSoulsCaptured = JMap.getInt(TargetData, "SCV_SoulsCaptured")
  If aiPerkLevel == 1 && Enchant >= 30 && SpiritLevel >= 1 && Level >= 15 && PlayerRef.hasPerk(SCVSet.SoulSqueezer)
    Return True
  ElseIf aiPerkLevel == 2 && Enchant >= 55 && SpiritLevel >= 2 && Level >= 30 && NumSoulsCaptured >= 30 && SCVSet.MGRArniel04.GetStage() == 200 ;Complete Arniel's Endeavor
    Return True
  ElseIf aiPerkLevel == 3 && Enchant >= 90 && Level >= 50 && NumSoulsCaptured >= 70 && SCVSet.MGRitual03.GetStage() == 200  ;Complete Conjuration Ritual Spell
    Return True
  EndIf
EndFunction
