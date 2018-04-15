ScriptName SCVIntenseHungerBuff Extends ActiveMagicEffect
{Magnitude = increase in stored limit}
Bool Property Setting_Recover Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  Int ActorData = SCLibrary.getActorData(akTarget)
  JMap.setInt(ActorData, "SCV_IntenseHunger", JMap.getInt(ActorData, "SCV_IntenseHunger") + (GetMagnitude() as Int))
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  If Setting_Recover
    Int ActorData = SCLibrary.getActorData(akTarget)
    JMap.setInt(ActorData, "SCV_IntenseHunger", JMap.getInt(ActorData, "SCV_IntenseHunger") - (GetMagnitude() as Int))
  EndIf
EndEvent
