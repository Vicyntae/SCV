ScriptName SCV_DEBUG_ForceSpecificAV2 Extends ActiveMagicEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Note("Target marked")
  Int TargetEvent = ModEvent.Create("SCV_DebugSAV2")
  ModEvent.PushForm(TargetEvent, akTarget)
  If ModEvent.send(TargetEvent)
    Note("ModEvent Sent!")
    Dispel()
  Else
    Note("ModEvent Not Sent!")
  EndIf
EndEvent

Function Note(String sMessage)
  Debug.Notification("[SCV Debug: FSAV2] " + sMessage)
EndFunction
