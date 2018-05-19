ScriptName SCVPerkExpiredEpicurian Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Description = New String[4]
  Description[0] = "Allows you to eat the undead."
  Description[1] = "Allows you to eat the undead."
  Description[2] = "Increases chances of success in devouring the undead by 5% and gives a chance of acquiring bonus items from them."
  Description[3] = "Increases chances of devouring the undead by 10%."

  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Have more than 150 Stamina, be at level 5, and defeat the conjurer keeping the lovers apart."
  Requirements[2] = "Have more than 200 Stamina, be at level 10, consume 5 undead, and retrieve the amulet that destroyed a family."
  Requirements[3] = "Have more than 300 Stamina, be at level 15, consume 15 undead, and wear the mysterious mask of Konahrik."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  If SCVLib.isPred(akTarget)
    Float Stamina = akTarget.GetBaseActorValue("Stamina")
    Int Level = akTarget.GetLevel()
    Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumUndeadEaten")
    If aiPerkLevel == 1 && Stamina >= 150 && Level >= 5 && SCVSet.dunAnsilvundQST.GetStage() == 100 ;Complete Ansilvund
      Return True
    ElseIf aiPerkLevel == 2 && Stamina >= 200 && Level >= 10 && NumEatenPrey >= 25 && SCVSet.dunGualdursonQST.GetStage() == 225 ;Complete Forbidden Legend
      Return True
    ElseIf aiPerkLevel == 3 && Stamina >= 300 && Level >= 15 && NumEatenPrey >= 15 && PlayerRef.HasMagicEffect(SCVSet.EnchDragonPriestUltraMaskEffect)  ;Obtain Konahrik
      Return True
    EndIf
  EndIf
EndFunction
