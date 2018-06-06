ScriptName SCVPerkNourish Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Name = "Nourishment"
  Description =  New String[4]
  Description[0] = "Gives health regeneration when one has digesting prey."
  Description[1] = "Gives slight health regeneration when one has digesting prey."
  Description[2] = "Gives slight health and stamina regeneration when one has digesting prey."
  Description[3] = "Gives slight health, stamina, and magicka regeneration when one has digesting prey."
  Requirements =  New String[4]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Have at least 20 Light Armor, have at least 200 Magicka, and discover the cause of a tragic fire."
  Requirements[2] = "Have at least 40 Light Armor, have at least 300 Magicka, and assist the wizard of the Blue Palace."
  Requirements[3] = "Have at least 60 Light Armor, have at least 400 Magicka and put an end to a sealed evil in Falkreath."
EndFunction

Function reloadMaintenence()
  Setup()
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  Int ArmorLevel = akTarget.GetActorValue("LightArmor") as Int
  Int Magicka = akTarget.GetActorValue("Magicka") as Int
  If aiPerkLevel == 1 && ArmorLevel >= 20 && Magicka >= 200 && SCVSet.MS14Quest.GetStage() == 200  ;Complete Laid to Rest
    Return True
  ElseIf aiPerkLevel == 2 && ArmorLevel >= 40 && Magicka >= 300 && SCVSet.Favor109.GetStage() == 20  ;Complete Kill the Vampire
    Return True
  ElseIf aiPerkLevel == 3 && ArmorLevel >= 60 && Magicka >= 400 && SCVSet.FreeformFalkreathQuest03B.GetStage() == 200  ;Complete Dark Ancestor
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
