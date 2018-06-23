ScriptName SCVPerkStalker Extends SCLPerkBase
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto

Function Setup()
  Name = "Stalker"
  Description = New String[4]
  Description[0] = "Increases swallow success chance when sneaking and unseen by your prey."
  Description[1] = "Increases swallow success chance by 5% when sneaking and unseen by your prey."
  Description[2] = "Increases swallow success chance by another 5% when sneaking and unseen by your prey. Increases movement speed slightly while you have struggling prey and are sneaking."
  Description[3] = "Increases swallow success chance by yet another 5% when sneaking and unseen by your prey. Increases movement speed significantly while you have struggling prey and are sneaking."

  Requirements = New String[4]
  Requirements[0] = "No Requirements."
  Requirements[1] = "Have at least 25 Sneak, be at least level 10, and have the ability to cast spells quietly."
  Requirements[2] = "Have at least 50 Sneak, be at least level 25, and join with the Nightingales."
  Requirements[3] = "Have at least 75 Sneak, be at least level 35 and pull off the greatest assassination in all of Tamriel."
EndFunction

Function reloadMaintenence()
  Setup()
EndFunction

Bool Function canTake(Actor akTarget, Int aiPerkLevel, Bool abOverride, Int aiTargetData = 0)
  If abOverride && aiPerkLevel >= 1 && aiPerkLevel <= 3
    Return True
  EndIf
  If SCVLib.isPred(akTarget)
    Float Sneak = akTarget.GetActorValue("Sneak")
    Int Level = akTarget.GetLevel()
    If aiPerkLevel == 1 && PlayerRef.HasPerk(SCVSet.QuietCasting) && Sneak >= 25 && Level >= 10
      Return True
    ElseIf aiPerkLevel == 2 && Sneak >= 50 && Level >= 25 && SCVSet.TG08A.IsCompleted() ;Complete Trinity Restored
      Return True
    ElseIf aiPerkLevel == 3 && Sneak >= 75 && Level >= 35 && SCVSet.DB11.IsCompleted() ;Complete Hail Sithis!
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
