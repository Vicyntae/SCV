ScriptName SCVTransferObject Extends ObjectReference

SCVLibrary Property SCVLib Auto
String Property DebugName
  String Function Get()
    Return "[SCV Transfer: " + TargetName + "] "
  EndFunction
EndProperty
Int DMID = 9

Actor TargetActor
Int TargetData
String TargetName
Int Contents
Int ItemType

Actor Property TransferTarget
  Function Set(Actor akActor)
    TargetActor = akActor
    TargetData = SCVLib.getTargetData(TargetActor)
    TargetName = SCVLib.nameGet(TargetActor)
  EndFunction
EndProperty
Int Property Type
  Function Set(Int a_val)
    If !SCVLib.SCVSet.SCA_Initialized || SCVLib.SCVSet.AVDestinationChoice == 1
      If a_val == 4 || a_val == 5
        a_val == 1
      ElseIf a_val == 6 || a_val == 7
        a_val == 2
      EndIf
    EndIf
    ItemType = a_val
    Contents = SCVLib.getContents(TargetActor, a_val)
  EndFunction
EndProperty

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If ItemType == 1 || ItemType == 2
    If akBaseItem as Potion || akBaseItem as Ingredient
      If !SCVLib.isInContainer(akBaseItem) && !SCVLib.isNotFood(akBaseItem)
        Int i = aiItemCount
        RemoveItem(akBaseItem, aiItemCount, True, TargetActor)
        While i
          If akItemReference
            TargetActor.EquipItem(akItemReference, False, True)
          Else
            TargetActor.EquipItem(akBaseItem, False, True)
          EndIf
          i -= 1
        EndWhile
      EndIf
    Else
      SCVLib.addItem(TargetActor, akItemReference, akBaseItem, ItemType,  aiItemCount = aiItemCount)
      If !akItemReference
        RemoveItem(akBaseItem, aiItemCount, True)
      EndIf
    EndIf
  ElseIf ItemType == 4 || ItemType == 6
    SCVLib.addItem(TargetActor, akItemReference, akBaseItem, 6,  aiItemCount = aiItemCount)
  ElseIf ItemType == 5 || ItemType == 7
    SCVLib.addItem(TargetActor, akItemReference, akBaseItem, 7,  aiItemCount = aiItemCount)
  EndIf

EndEvent

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Debug Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Function Popup(String sMessage)
  SCVLib.ShowPopup(sMessage, DebugName)
EndFunction

Function Note(String sMessage)
  SCVLib.ShowNote(sMessage, DebugName)
EndFunction

Function Notice(String sMessage, Int aiID = 0)
  Int ID
  If aiID > 0
    ID = aiID
  Else
    ID = DMID
  EndIf
  SCVLib.showNotice(sMessage, ID, DebugName)
EndFunction

Function Issue(String sMessage, Int iSeverity = 0, Int aiID = 0, Bool bOverride = False)
  Int ID
  If aiID > 0
    ID = aiID
  Else
    ID = DMID
  EndIf
  SCVLib.ShowIssue(sMessage, iSeverity, ID, bOverride, DebugName)
EndFunction
