ScriptName SCVAlphaSetSpell Extends ActiveMagicEffect

Float Property Setting_Alpha = 0.0 Auto
Bool Property Setting_Fade = False Auto
Float Property Setting_ReturnAlpha = 1.0 Auto
Event OnEffectStart(Actor akTarget, Actor akCaster)
  akTarget.SetAlpha(Setting_Alpha, Setting_Fade)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  akTarget.SetAlpha(Setting_ReturnAlpha, Setting_Fade)
EndEvent
