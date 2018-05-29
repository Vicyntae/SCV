ScriptName SCVPerkSpiritSwallower Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Name = "Spirit Swallower"
  Description = New String[4]
  Description[0] = "Allows you to eat ghosts."
  Description[1] = "Allows you to eat ghosts."
  Description[2] = "Increases chances of success in devouring ghosts by 5% and gives a chance of acquiring bonus items from them."
  Description[3] = "Increases chances of devouring ghosts by 10%."

  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Have more than 150 magicka, be at level 5, and discover the source of the mysterious events happening in Ivarstead."
  Requirements[2] = "Have more than 200 magicka, be at level 10, consume 5 spirits, and free the spirits trapped in the maze."
  Requirements[3] = "Have more than 300 magicka, be at level 15, consume 15 spirits, and stop a terrible evil from being reawakened."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  If SCVLib.isPred(akTarget)
    Float Magicka = akTarget.GetBaseActorValue("Magicka")
    Int Level = akTarget.GetLevel()
    Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumGhostsEaten")
    If aiPerkLevel == 1 && Magicka >= 150 && Level >= 5 && SCVSet.FreeformIvarstead01.GetStage() == 200 ;Complete Quest Lifting the Shroud.
      Return True
    ElseIf aiPerkLevel == 2 && Magicka >= 200 && Level >= 10 && NumEatenPrey >= 5 && SCVSet.MG07.GetStage() == 200 ;Complete The Staff of Magnus
      Return True
    ElseIf aiPerkLevel == 3 && Magicka >= 300 && Level >= 15 && NumEatenPrey >= 15 && SCVSet.MS06.GetStage() == 250  ;Complete The Wolf Queen Awakened.
      Return True
    EndIf
  EndIf
EndFunction

Bool Function isKnown(Actor akTarget)
  If SCVLib.isPred(PlayerRef)
    Return True
  Else
    Return False
  EndIf
EndFunction
