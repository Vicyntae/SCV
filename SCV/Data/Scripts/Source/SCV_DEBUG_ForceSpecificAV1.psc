ScriptName SCV_DEBUG_ForceSpecificAV1 Extends ActiveMagicEffect

Spell Property SCV_TakeInLethal Auto
Spell Property SCV_TakeInNonLethal Auto

Bool Property Setting_Lethal Auto

GlobalVariable Property SCV_TargetingState Auto

SCVLibrary Property SCVLib Auto
Actor akPred
Event OnEffectStart(Actor akTarget, Actor akCaster)
  akPred = akTarget
  RegisterForModEvent("SCV_DebugSAV2", "OnTargetFound")
  SCV_TargetingState.SetValueInt(1)
  Note("Choose Target")
  RegisterForSingleUpdate(30)
EndEvent

Event OnTargetFound(Form akPrey)
  If akPrey as Actor && akPrey != akPred
    UnregisterForUpdate()
    Note("Target " + (akPrey as Actor).GetLeveledActorBase().GetName() + " Acquired.")
    Bool Success
    If (akPrey as Actor).GetDistance(akPred) <= 128
      Note("Starting Vore")
      Success = True
    Else
      Note("Target too far. Moving...")
      If akPred.PathToReference(akPrey as Actor, 1)
        Note("Move completed, Starting Vore")
        Success = True
      Else
        Note("Move not completed")
      EndIf
    EndIf
    If Success
      If Setting_Lethal
        SCV_TakeInLethal.Cast(akPred, akPrey as Actor)
      Else
        SCV_TakeInNonLethal.Cast(akPred, akPrey as Actor)
      EndIf
    EndIf
    Dispel()
  EndIf
EndEvent

Event OnUpdate()
  Note("Targeting timed out.")
  Dispel()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  Note("Resetting targeting state...")
  SCV_TargetingState.SetValueInt(0)
EndEvent

Function Note(String sMessage)
  Debug.Notification("[SCV Debug: FSAV1] " + sMessage)
EndFunction
