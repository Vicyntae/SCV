ScriptName SCVPerkConstriction Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Name = "Constriction"
  Description = New String[4]
  Description[0] = "Increases stamina/magicka damage done to struggling prey."
  Description[1] = "Increases stamina/magicka damage done to struggling prey slightly."
  Description[2] = "Increases stamina/magicka damage done to struggling prey moderately."
  Description[3] = "Increases stamina/magicka damage done to struggling prey significantly."
  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Have at least 20 Heavy Armor, have at least 200 Stamina, and infiltrate an ancient fort on the behalf of another."
  Requirements[2] = "Have at least 40 Heavy Armor, have at least 300 Stamina, and help a young woman discover the truth about her companion."
  Requirements[3] = "Have at least 60 Heavy Armor, have at least 400 Stamina and help set a man's wife free."
EndFunction
Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int ArmorLevel = akTarget.GetActorValue("HeavyArmor") as Int
  Int Stamina = akTarget.GetActorValue("Stamina") as Int
  If aiPerkLevel == 1 && ArmorLevel >= 20 && Stamina >= 200 && SCVSet.dunTrevasWatchQST.GetStage() == 100 ;Complete Infiltration
    Return True
  ElseIf aiPerkLevel == 2 && ArmorLevel >= 40 && Stamina >= 300 && SCVSet.dunIronbindQST.GetStage() == 200  ;Complete Coming of Age at Ironbind Barrow
    Return True
  ElseIf aiPerkLevel == 3 && ArmorLevel >= 60 && Stamina >= 400 && SCVSet.dunMistwatchQST.GetStage() == 100
    Return True
  EndIf
EndFunction

Bool Function isKnown(Actor akTarget)
  If SCVLib.isPred(PlayerRef)
    Return True
  Else
    Return False
  EndIf
EndFunction
