ScriptName SCV_DEBUG_ForceSpecificOV2 Extends ActiveMagicEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Note("Target marked")
  Int TargetEvent = ModEvent.Create("SCV_DebugSOV2")
  ModEvent.PushForm(TargetEvent, akTarget)
  If ModEvent.send(TargetEvent)
    Note("ModEvent Sent!")
    Dispel()
  Else
    Note("ModEvent Not Sent!")
  EndIf
EndEvent

Function Note(String sMessage)
  Debug.Notification("[SCV Debug: FSOV2] " + sMessage)
EndFunction
