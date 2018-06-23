ScriptName SCV_dunDA14PortalEnable Extends ObjectReference

GlobalVariable Property SCV_dunDA14PortalEnabledVar Auto
ObjectReference Property SanguinesRealmDoorRef Auto
ObjectReference Property FXDA14PortalDoor Auto
ObjectReference Property dunDA14FXLightREF Auto

Int InTrigger = 0
Event OnTriggerEnter(ObjectReference akActionRef)
  If SCV_dunDA14PortalEnabledVar.GetValueInt() > 0
    If InTrigger == 0
      If akActionRef == Game.GetPlayer()
        InTrigger += 1
        SanguinesRealmDoorRef.Enable(True)
        FXDA14PortalDoor.Enable(True)
        dunDA14FXLightREF.Enable(True)
      EndIf
    EndIf
  EndIf
EndEvent

Event OnTriggerLeave(ObjectReference akActionRef)
  If InTrigger > 0
    If akActionRef == Game.GetPlayer()
      InTrigger -= 1
      SanguinesRealmDoorRef.Disable(True)
      FXDA14PortalDoor.Disable(True)
      dunDA14FXLightREF.Disable(True)
    EndIf
  EndIf
EndEvent
