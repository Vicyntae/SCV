ScriptName SCV_DEBUG_ForceAV Extends ActiveMagicEffect

Spell Property SCV_TakeInLethal Auto
Spell Property SCV_TakeInNonLethal Auto
Bool Property Setting_Lethal Auto
SCVLibrary Property SCVLib Auto
Event OnEffectStart(Actor akTarget, Actor akCaster)
  Note("Forcing Vore")
  If Setting_Lethal
    SCV_TakeInLethal.Cast(akTarget, akCaster)
  Else
    SCV_TakeInNonLethal.Cast(akTarget, akCaster)
  EndIf
EndEvent

Function Note(String sMessage)
  Debug.Notification("[SCV Debug: FAV] " + sMessage)
EndFunction
