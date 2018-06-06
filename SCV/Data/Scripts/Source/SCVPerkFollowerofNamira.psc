ScriptName SCVPerkFollowerofNamira Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Name = "Follower of Namira"
  Description = New String[4]
  Description[0] = "Allows you to eat humans."
  Description[1] = "Allows you to eat humans."
  Description[2] = "Increases chances of success in devouring humans by 5% and gives a chance of acquiring bonus items from them."
  Description[3] = "Increases chances of success in devouring humans by 10%."

  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Have more than 150 health, be at level 5, and experience contact with the Lady of Decay."
  Requirements[2] = "Have more than 250 health, be at level 10, consume 30 humans, and discover your inner beast for the first time."
  Requirements[3] = "Have more than 350 health, be at level 30, consume 60 humans, and devour 10 important people."
EndFunction

Function reloadMaintenence()
  Setup()
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  If SCVLib.isPred(akTarget)
    Float Health = akTarget.GetBaseActorValue("Health")
    Int Level = akTarget.GetLevel()
    Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumHumansEaten")
    If aiPerkLevel == 1 && Health >= 150 && Level >= 5 && (SCVSet.DA11Intro.GetStage() == 20 || SCVSet.DA11Intro.GetStage() == 200) ;Complete Quest Investigate the Hall of The Dead
      Return True
    ElseIf aiPerkLevel == 2 && Health >= 250 && Level >= 10 && NumEatenPrey >= 30 && (SCVSet.DA05.GetStage() == 100 || SCVSet.DA05.GetStage() == 105 || SCVSet.DA05.GetStage() == 205 || SCVSet.C03.GetStage() == 200) ;Complete (or fail) Quest Ill Met By Moonlight || The Silver Hand
      Return True
    ElseIf aiPerkLevel == 3 && Health >= 350 && Level >= 30 && NumEatenPrey >= 100 && JMap.getInt(TargetData, "SCV_ImportantNPCsEaten") >= 10
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
