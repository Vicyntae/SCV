ScriptName SCV_dunDA14ReturnEnable Extends ObjectReference

GlobalVariable Property SCV_dunDA14PortalEnabledVar Auto
ObjectReference Property dunda14PortalDoor01 Auto

Event OnInit()
  dunda14PortalDoor01.Disable(False)
EndEvent

Int InTrigger = 0
Event OnTriggerEnter(ObjectReference akActionRef)
  If SCV_dunDA14PortalEnabledVar.GetValueInt() > 0
    If InTrigger == 0
      If akActionRef == Game.GetPlayer()
        InTrigger += 1
        dunda14PortalDoor01.Enable(True)
      EndIf
    EndIf
  EndIf
EndEvent

Event OnTriggerLeave(ObjectReference akActionRef)
  If SCV_dunDA14PortalEnabledVar.GetValueInt() > 0
    If InTrigger > 0
      If akActionRef == Game.GetPlayer()
        InTrigger -= 1
        dunda14PortalDoor01.Disable(True)
      EndIf
    EndIf
  EndIf
EndEvent
