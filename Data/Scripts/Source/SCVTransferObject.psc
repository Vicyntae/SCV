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
Int Property InsertType Auto

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If InsertType == 1  ;Insert everything into specified type. No edits.
    SCVLib.addItem(TargetActor, akItemReference, akBaseItem, ItemType, aiItemCount = aiItemCount)
    If !akItemReference
      RemoveItem(akBaseItem, aiItemCount, True)
    EndIf
  ElseIf InsertType == 2  ;Separate everything based on primary type and digestability (1,2 for stomach, 4,5 for anus)
    Int CurrentType ;Rewrite this once we differetiate anal and oral vore
    If (akBaseItem as Potion || akBaseItem as Ingredient) && SCVLib.isDigestible(akBaseItem)
      CurrentType = 1
    Else
      CurrentType = 2
    EndIf
    String ItemName = SCVLib.nameGet(akBaseItem)  ;For some reason a "Null" Item keeps being added without any name, and doesn't show up when vomited
    If !ItemName
      Return
    EndIf
    ;Note("Item Added! Form = " + ItemName + ", ItemType = " + CurrentType + ", NumItems = " + aiItemCount)
    While aiItemCount
      If CurrentType == 1
        If akItemReference
          RemoveItem(akItemReference, 1, False, TargetActor)
          TargetActor.EquipItem(akItemReference, False, False)
        Else
          RemoveItem(akBaseItem, 1, False, TargetActor)
          TargetActor.EquipItem(akBaseItem, False, False)
        EndIf
      ElseIf CurrentType == 2
        SCVLib.addItem(TargetActor, akItemReference, akBaseItem, 2)
        If !akItemReference
          RemoveItem(akBaseItem, 1, False)
        EndIf
      EndIf
      aiItemCount -= 1
    EndWhile
  ;ElseIf InsertType == 3 ???
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
