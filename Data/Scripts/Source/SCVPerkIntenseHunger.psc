ScriptName SCVPerkIntenseHunger Extends SCLPerkBase
SCVLibrary Property SCVLib Auto

Function Setup()
  Description = New String[4]
  Description[0] = "Increases chance of success of swallow spells."
  Description[1] = "Increases success chance of swallow spells by 5%."
  Description[2] = "Increases success chance of swallow spells by another 5%."
  Description[3] = "Increases success chance of swallow spells by 10%."

  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Have an oral predator skill level of 15 and consume 10 prey."
  Requirements[2] = "Have an oral predator skill level of 35 and consume 35 prey."
  Requirements[3] = "Have an oral predator skill level of 60 and consume 150 prey."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  If SCVLib.isOVPred(akTarget, TargetData)
    Int Req1
    Int Req2
    If aiPerkLevel == 1
      Req1 = 10
      Req2 = 15
    ElseIf aiPerkLevel == 2
      Req1 = 60
      Req2 = 35
    ElseIf aiPerkLevel == 3
      Req1 = 150
      Req2 = 60
    EndIf
    Int OVLevel = SCVLib.getOVLevelTotal(akTarget, TargetData)
    Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumOVPreyEaten")
    If aiPerkLevel <= 3 && NumEatenPrey >= Req2 && OVLevel >= Req2
      Return True
    EndIf
  EndIf
EndFunction
