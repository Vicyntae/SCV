ScriptName SCVGeneralPredBuff Extends SCLGeneralBuff
{Magnitude = Perk increase amount
Same as general buff, but also checks pred status afterwards.}
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto
Event OnEffectStart(Actor akTarget, Actor akCaster)
  Parent.OnEffectStart(akTarget, akCaster)
  SCVLib.checkPredAbilities(akTarget)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  Parent.OnEffectFinish(akTarget, akCaster)
  SCVLib.checkPredAbilities(akTarget)
EndEvent
