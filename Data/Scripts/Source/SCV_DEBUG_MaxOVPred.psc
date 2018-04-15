ScriptName SCV_DEBUG_MaxOVPred Extends ActiveMagicEffect

SCVLibrary Property SCVLib Auto
Event OnEffectStart(Actor akTarget, Actor akCaster)
  SCVLib.debugMaxPredStats(akTarget)
  Note("Stats maximized!")
EndEvent

Function Note(String sMessage)
  Debug.Notification("[SCV Debug: MPS] " + sMessage)
EndFunction
