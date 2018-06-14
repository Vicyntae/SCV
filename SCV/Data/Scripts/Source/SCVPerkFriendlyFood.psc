ScriptName SCVPerkFriendlyFood Extends SCLPerkBase

SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Quest Property MS05 Auto  ;Tending the Flames, 300
Quest Property DA02 Auto  ;Boethiah's Calling, 50
Quest Property TGLeadership Auto  ;Under New Management, 200
Perk Property Haggling20 Auto
Perk Property Intimidation Auto
Function Setup()
  Name = "Friendly Food"
  Description = New String[6]
  Description[0] = "Allows certain prey to trust you"
  Description[1] = "Allows you to nonlethally devour followers without consequence."
  Description[2] = "Allows you to nonlethally devour NPCs you're friends with without consequence."
  Description[3] = "Allows you to lethally devour followers without consequence."
  Description[4] = "Allows you to lethally devour NPCs you're friends with without consequence."
  Description[5] = "Allows you to lethally devour any actor without consequence."

  Requirements = New String[6]
  Requirements[0] = "No Requirements"
  Requirements[1] = "Have at least 25 Speechcraft, be at level 20, and posess the perk \"Haggling 2\""
  Requirements[2] = "Have at least 40 Speechcraft, be at level 35, and learn to lower people's guard using the skill of the bard."
  Requirements[3] = "Have at least 55 Speechcraft, be at level 50, and prove the extent of your treachery to the Prince of Deceit."
  Requirements[4] = "Have at least 70 Speechcraft, be at level 60, and poesses the perk \"Intimidation\"."
  Requirements[5] = "Have at least 90 Speechcraft, be at level 70, and possess the Amulet of Articulation."
EndFunction

Function reloadMaintenence()
  Setup()
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= AbilityArray.Length - 1
    Return True
  EndIf
  Int TargetData = SCVLib.getData(akTarget, aiTargetData)
  If SCVLib.isPred(akTarget)
    Float Speech = akTarget.GetActorValue("Speechcraft")
    Int Level = akTarget.GetLevel()
    If aiPerkLevel == 1 && Speech >= 25 && Level >= 20 && PlayerRef.hasPerk(Haggling20)
      Return True
    ElseIf aiPerkLevel == 2 && Speech >= 40 && Level >= 35 && MS05.GetStage() >= 300
      Return True
    ElseIf aiPerkLevel == 3 && Speech >= 55 && Level >= 50 && DA02.GetStage() >= 50
      Return True
    ElseIf aiPerkLevel == 4 && Speech >= 70 && Level >= 60 && PlayerRef.HasPerk(Intimidation)
      Return True
    ElseIf aiPerkLevel == 5 && Speech >= 90 && Level >= 70 && TGLeadership.GetStage() >= 200
      Return True
    EndIf
  EndIf
  Return False
EndFunction

Bool Function isKnown(Actor akTarget)
  If SCVLib.isPred(PlayerRef)
    Return True
  Else
    Return False
  EndIf
EndFunction
