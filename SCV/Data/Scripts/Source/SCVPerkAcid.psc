ScriptName SCVPerkAcid Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Name = "Strong Acid"
  Description = New String[4]
  Description[0] = "Deals health damage to struggling prey."
  Description[1] = "Deals slight health damage to struggling prey."
  Description[2] = "Deals moderate health damage to struggling prey."
  Description[3] = "Deals heavy health damage to struggling prey."

  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Have a Digestion Rate of at least 4 and digest at least 350 units of food."
  Requirements[2] = "Have a Digestion Rate of at least 10 and digest at least 700 units of food."
  Requirements[3] = "Have a Digestion Rate of at least 20 and digest at least 1200 units of food."
EndFunction

Function reloadMaintenence()
  Setup()
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  If SCVLib.isPred(akTarget)
    Float DigestRate = JMap.getFlt(TargetData, "STDigestionRate")
    Float NumFoodEaten = JMap.getFlt(TargetData, "STTotalDigestedFood")
    Float Req1
    Float Req2
    If aiPerkLevel == 1
      Req1 = 4
      Req2 = 350
    ElseIf aiPerkLevel == 2
      Req1 = 10
      Req2 = 700
    ElseIf aiPerkLevel == 3
      Req1 = 20
      Req2 = 1200
    EndIf
    If aiPerkLevel <= 3 && (abOverride || (DigestRate >= Req1 && NumFoodEaten >= Req2))
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
