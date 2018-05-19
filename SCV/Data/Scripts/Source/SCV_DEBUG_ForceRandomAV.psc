ScriptName SCV_DEBUG_ForceRandomAV Extends ActiveMagicEffect

SCVLibrary Property SCVLib Auto

Bool Property Setting_Lethal Auto

Spell Property SCV_TakeInLethal Auto
Spell Property SCV_TakeInNonLethal Auto

Actor Property PlayerRef Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Actor Victim = None
  Int i = 0
  Note("Forcing Random Vore, Searching for potential victim")
  While !Victim && i < 10
    Victim = Game.FindRandomActorFromRef(akTarget, 1024)
    If Victim == akTarget || Victim == PlayerRef
      Victim = None
    EndIf
    i += 1
    ;Debug.Notification("Attempt " + i)
  EndWhile
  If Victim == akTarget || Victim == PlayerRef
    Victim = None
  EndIf
  If Victim
    Note("Target " + Victim.GetLeveledActorBase().GetName() + " Acquired.")
    Bool Success
    If Victim.GetDistance(akTarget) > 128
      Note("Target too far. Moving...")
      If akTarget.PathToReference(Victim, 1)
        Note("Move completed. Starting Vore")
        Success = True
      Else
        Note("Move not completed. Canceling")
      EndIf
    EndIf
    If Success
      If Setting_Lethal
        SCV_TakeInLethal.Cast(akTarget, Victim)
      Else
        SCV_TakeInNonLethal.Cast(akTarget, Victim)
      EndIf
    EndIf
  Else
    Note("No other actors found!")
  EndIf
EndEvent

Function Note(String sMessage)
  Debug.Notification("[SCV Debug: FRAV] " + sMessage)
EndFunction
