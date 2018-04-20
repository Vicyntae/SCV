ScriptName SCVAutoCastSpellOnAcquire Extends ObjectReference

Bool Property Setting_RestrictToFromPlayer Auto
Bool Property Setting_RestrictPlayer Auto
Spell Property Setting_CastSpell Auto
Bool Property Setting_DeleteAfterCast Auto
Bool Property Setting_RemoveItemAfterCast Auto
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
  If akNewContainer as Actor
    Actor PlayerRef = Game.GetPlayer()
    If Setting_RestrictPlayer && akNewContainer == PlayerRef
      Return
    EndIf
    If Setting_RestrictToFromPlayer && akOldContainer != PlayerRef
      Return
    EndIf
    Setting_CastSpell.Cast(akNewContainer as Actor)
    If Setting_RemoveItemAfterCast
      akNewContainer.RemoveItem(Self, 1, False)
    EndIf
  EndIf
EndEvent
