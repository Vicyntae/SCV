ScriptName SCVPerkDragonDevourer Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Name = "Dragon Devourer"
  Description = New String[4]
  Description[0] = "Allows you to eat dragons."
  Description[1] = "Allows you to eat dragons."
  Description[2] = "Increases chances of success in devouring dragons by 5%."
  Description[3] = "Increases chances of success in devouring dragons by another 5% and gives a chance of acquiring bonus items from them."

  Requirements = New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Slay more than 30 dragons, be at level 30, and learn more about your nemesis."
  Requirements[2] = "Slay more than 70 dragons, consume 20 of them, be at level 50, and defeat the one who will consume the world."
  Requirements[3] = "Slay more than 100 dragons, consume 100 of them, be at level 70, and consume the essence of dragons at least 10 times."
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
    Int DragonsKilled = SCVSet.DragonsAbsorbed.GetValueInt()
    Int CurrentDragonSouls = JMap.getInt(SCVLib.getTargetData(PlayerRef), "SCV_DragonGemsConsumed")
    Int Level = akTarget.GetLevel()
    Int NumEatenPrey = JMap.getInt(TargetData, "SCV_NumDragonsEaten")
    If aiPerkLevel == 1 && DragonsKilled >= 30 && Level >= 30 && SCVSet.MQ203.GetStage() == 280 ;Complete Quest Alduin's Wall
      Return True
    ElseIf aiPerkLevel == 2 && DragonsKilled >= 70 && Level >= 50 && NumEatenPrey >= 20 && SCVSet.MQ305.GetStage() == 200 ;Complete Quest Dragonslayer
      Return True
    ElseIf aiPerkLevel == 3 && DragonsKilled >= 100 && Level >= 70 && NumEatenPrey >= 100 && CurrentDragonSouls >= 10
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
