ScriptName SCVInsertItemsContainer Extends ObjectReference

SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
Actor MyActor
Int ItemType
Bool Working
Bool Processing

Bool Function prepInsert(Actor akTarget, Int aiItemType)
  If Working
    While Working
      Utility.Wait(0.5)
    EndWhile
  EndIf
  If !akTarget || !aiItemType
    Return False
  EndIf
  Working = True
  MyActor = akTarget
  ItemType = aiItemType
  Return True
EndFunction

Function finishInsert()
  If Processing
    While Processing
      Utility.Wait(0.5)
    EndWhile
  EndIf
  MyActor = None
  ItemType = 0
  RemoveAllItems()
  Working = False
EndFunction

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If Working && MyActor && ItemType
    Processing = True
    SCVLib.addItem(MyActor, akItemReference, akBaseItem, ItemType, aiItemCount = aiItemCount)
    RegisterForSingleUpdate(1)
  EndIf
EndEvent

Event OnUpdate()
  Processing = False
EndEvent
