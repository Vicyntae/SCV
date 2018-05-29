ScriptName SCVPerkMetalMuncher Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Name = "Metal Muncher"
  Description = New String[4]
  Description[0] = "Allows you to eat Dwemer Automatons."
  Description[1] = "Allows you to eat Dwemer Automatons."
  Description[2] = "Increases chances of success in devouring Dwemer Automatons by 5% and gives a chance of acquiring bonus items from them."
  Description[3] = "Increases chances of success in devouring Dwemer Automatons by 10%."

  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Have a digestion rate of at least 2, be at level 15, and possess the knowledge of the ancient Dwemer."
  Requirements[2] = "Have a digestion rate of at least 5, be at level 25, consume 30 Dwemer Automatons, and discover the secret of the Dwemer Oculory."
  Requirements[3] = "Have a digestion rate of at least 8, be at level 30, consume 60 Dwemer Automatons, and unlock the container with the heart of a god."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  If SCVLib.isPred(akTarget)
    Float DigestRate = JMap.getFlt(TargetData, "STDigestionRate")
    Int Level = akTarget.GetLevel()
    Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumDwarvenEaten")
    If aiPerkLevel == 1 && DigestRate >= 2 && Level >= 15 && PlayerRef.HasSpell(SCVSet.MS04Reward) ;Complete quest Unfathomable Depths
      Return True
    ElseIf aiPerkLevel == 2 && DigestRate >= 5 && Level >= 25 && NumEatenPrey >= 30 && SCVSet.MG06.GetStage() == 200 ;Complete Quest Revealing the Unseen
      Return True
    ElseIf aiPerkLevel == 3 && DigestRate >= 8 && Level >= 30 && NumEatenPrey >= 60 && (SCVSet.DA04.GetStage() == 100 || SCVSet.DA04.GetStage() == 105)  ;Complete (or fail) Quest Discerning the Transmundane
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
