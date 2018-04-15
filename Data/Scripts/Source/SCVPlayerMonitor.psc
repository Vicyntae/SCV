ScriptName SCVPlayerMonitor Extends SCVMonitor

Event OnInit()
  Notice("Beginning Player monitor setup")
  Setup()
EndEvent

Function Setup()
  Parent.Setup()
  RegisterForModEvent("SCLActionKeyChange", "OnActionKeyChange")
  RegisterForKey(SCLSet.ActionKey)
  UnregisterForMenu("Console")
  RegisterForMenu("Console")
EndFunction

Function reloadMaintenence()
  Parent.reloadMaintenence()
  RegisterForModEvent("SCLActionKeyChange", "OnActionKeyChange")
  UnregisterForMenu("Console")
  RegisterForMenu("Console")
EndFunction

Event OnActionKeyChange(Int aiActionKey)
  Notice("Action key changed")
  UnregisterForAllKeys()
  RegisterForKey(aiActionKey)
EndEvent

Event OnMenuOpen(string menuName)
  If menuName == "Console"
    RegisterForKey(28)
    RegisterForKey(156)
  EndIf
EndEvent

Event OnMenuClose(string menuName)
  If menuName == "Console"
    UnregisterForKey(28)
    UnregisterForKey(156)
  EndIf
EndEvent

Event OnKeyDown(int keyCode)
  If keyCode == SCLSet.ActionKey
    If Utility.IsInMenuMode()
      Return
    EndIf
    Notice("Action Key Pressed")
    ObjectReference CurrentRef = Game.GetCurrentCrosshairRef()
    If !LockEX()
      Return
    EndIf
    If !CurrentRef
      Notice("Sending menu open event for " + SCVLib.nameGet(MyActor))
      SCVLib.sendActorMainMenuOpenEvent(MyActor, 0)
    ElseIf CurrentRef as Actor
      If SCLSet.UIExtensionsInstalled
        Notice("Sending menu open event for " + SCVLib.nameGet(CurrentRef))
        SCVLib.sendActorMainMenuOpenEvent(CurrentRef as Actor, 0)
      Else
        Notice("Opening transfer menu for " + SCVLib.nameGet(CurrentRef))
        SCVLib.openTransferMenu(CurrentRef as Actor)
      EndIf
    Else
      Form CurrentBase = CurrentRef.GetBaseObject()
      If CurrentBase as Potion || CurrentBase as Ingredient || CurrentBase as Ammo || CurrentBase as Armor || CurrentBase as Book || CurrentBase as LeveledItem || CurrentBase as MiscObject || CurrentBase as SoulGem || CurrentBase as Scroll || CurrentBase as Weapon
        ;Later: make it so that potions/ingredients not in containers are eaten?
        Notice("Adding " + SCVLib.nameGet(CurrentRef) + " to stomach")
        SCVLib.addItem(MyActor, CurrentRef, aiItemType = 2)
        SCVLib.updateSingleContents(MyActor, 2)
        SCVLib.quickUpdate(MyActor)
      EndIf
    EndIf
    UnlockEX()
  ElseIf keyCode == 28 || keyCode == 156
    ;Console Interface ---------------------------------------------------------
    ;Taken from post by milzschnitte
    ;https://www.loverslab.com/topic/58600-skyrim-custom-console-commands-using-papyrus/

    ;NEXT: provide console interface for setting options
    ;Cannot currently view stomach contents

    Int cmdCount = UI.GetInt("Console", "_global.Console.ConsoleInstance.Commands.length")
    If cmdCount > 0
      cmdCount -= 1
      String cmdLine = UI.GetString("Console","_global.Console.ConsoleInstance.Commands."+cmdCount)
      If cmdLine != ""
        Actor akTarget = Game.GetCurrentConsoleRef() as Actor
        If akTarget == None
          akTarget = PlayerRef
        EndIf
        Int TargetData = SCVLib.getTargetData(akTarget)
        String[] cmd = StringUtil.Split(cmdLine, " ")
        SCVLib.processConsoleInput(akTarget, cmd)
      EndIf
    EndIf
  EndIf
EndEvent

;Update Functions **************************************************************
Function performDailyUpdate(Actor akTarget)
  {Performs functions that should be done daily.}
  If SCVLib.canTakeAnyPerk(akTarget)
    SCVLib.sendTakePerkMessage(akTarget)
  EndIf
EndFunction
