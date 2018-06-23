ScriptName SCVPerkCorneredRat Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto


Function Setup()
  Name = "Cornered Rat"
  Description = New String[4]
  Description[0] = "Deals health damage to one's pred."
  Description[1] = "Deals slight health damage to one's predator."
  Description[2] = "Deals moderate health damage to one's predator."
  Description[3] = "Deals heavy health damage to one's predator."

  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Be eaten at least once and survive, and locate a man hiding for his life surrounded by rats."
  Requirements[2] = "Be eaten at least 5 times and survive, and put an end to the man who sealed himself away for a chance at power."
  Requirements[3] = "Be eaten at least 15 times and survive, and help capture a powerful beast."
EndFunction

Function reloadMaintenence()
  Setup()
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  If aiPerkLevel == 1 && JMap.getInt(TargetData, "SCV_NumTimesEaten") >= 1 && SCVSet.MQ202.IsCompleted()  ;Complete A Cornered Rat
    Return True
  ElseIf aiPerkLevel == 2 && JMap.getInt(TargetData, "SCV_NumTimesEaten") >= 5 && SCVSet.MG08.IsCompleted() ;Complete The Eye of Magnus
    Return True
  ElseIf aiPerkLevel == 3 && JMap.getInt(TargetData, "SCV_NumTimesEaten") >= 15 && SCVSet.MQ301.IsCompleted() ; Complete The Fallen
    Return True
  EndIf
EndFunction
