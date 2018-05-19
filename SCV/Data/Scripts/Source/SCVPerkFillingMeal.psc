ScriptName SCVPerkFillingMeal Extends SCLPerkBase
SCVLibrary Property SCVLib Auto

Function Setup()
  Description = New String[4]
  Description[0] = "Increase's one's size while inside a predator."
  Description[1] = "Increase's one's size while inside a predator by 20%."
  Description[2] = "Increase's one's size while inside a predator by 40%."
  Description[3] = "Increase's one's size while inside a predator by 60%."
  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Take up at least 300 units in a prey's stomach and be at level 15."
  Requirements[2] = "Take up at least 500 units in a prey's stomach, be at level 25, and have a resistance skill of at least 30."
  Requirements[3] = "Take up at least 800 units in a prey's stomach, be at level 35, and have a resistance skill of at least 50."
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  Float DigestValue = SCVLib.genDigestValue(akTarget, True)
  Int Level = akTarget.GetLevel()
  Int Resist = SCVLib.getResLevel(akTarget, TargetData)
  If aiPerkLevel == 1 && DigestValue >= 300 && Level >= 15
    Return True
  ElseIf aiPerkLevel == 2 && DigestValue >= 500 && Resist >= 30 && Level >= 25
    Return True
  ElseIf aiPerkLevel == 3 && DigestValue >= 800 && Resist >= 50 && Level >= 35
    Return True
  EndIf
EndFunction
