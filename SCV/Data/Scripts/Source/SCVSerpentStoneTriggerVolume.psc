ScriptName SCVSerpentStoneTriggerVolume Extends ObjectReference

Int InTrigger = 0

Event OnTriggerEnter(ObjectReference akTriggerRef)
	if (InTrigger == 0)
		if akTriggerRef == Game.GetPlayer()
			InTrigger += 1
      GetLinkedRef().GoToState("PlayerNear")
			;debug.notification("Entered Trigger")
		endif
	endif
EndEvent

Event OnTriggerLeave(ObjectReference akTriggerRef)
	if (InTrigger > 0)
		if akTriggerRef == Game.GetPlayer()
			InTrigger -= 1
      GetLinkedRef().GoToState("PlayerFar")
			;debug.notification("Leaving Trigger")
		endif
	endif
EndEvent
