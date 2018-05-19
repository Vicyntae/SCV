ScriptName SCVStayWithMe Extends ReferenceAlias
{Hides an actor's and keeps them near the alias}

SCLSettings Property SCLSet Auto
SCVLibrary Property SCVLib Auto
SCVSettings Property SCVSet Auto
Actor Property PlayerRef Auto
Int DelayUpdate

Int DMID = 8
String ScriptID = "SCV Follow"
String Property DebugName
  String Function Get()
    Return "[" + ScriptID + " " + ": " + GetActorReference().GetLeveledActorBase().GetName() + "] "
  EndFunction
EndProperty
Form Property CameraBase Auto
ObjectReference CameraObject
Float[] CameraPosition

Function addToDelayCounter()
  DelayUpdate += 1
EndFunction

Function removeFromDelayCounter()
  DelayUpdate -= 1
EndFunction

Function ForceRefTo(ObjectReference akNewRef)
  ;If there is no current alias, will hide the player and fill
  ;Else, just changes the alias
  If akNewRef as Actor
    If !GetActorReference()
      ;Note(SCVLib.nameGet(MyPred) + " is player pred! Hiding player.")
      Actor MyPred = akNewRef as Actor
      PlayerRef.SetPosition(MyPred.GetPositionx() + 2000, MyPred.GetPositionY() + 2000, MyPred.GetPositionZ())
      PlayerRef.SetAlpha(0, False)
      PlayerRef.SetGhost(True)
      ;game.DisablePlayerControls(true, true, true, false, true, true, true, false, 0)
      Game.DisablePlayerControls(False, False, False, False, False, True, True, False, 0)
      Game.ForceThirdPerson()
      Game.SetCameraTarget(MyPred)
      ;Game.ForceFirstPerson()
      If MyPred.IsPlayerTeammate()
        Game.EnablePlayerControls()
        MyPred.SetPlayerControls(True)
        MyPred.EnableAI(True)
      EndIf
      PlayerRef.SetPlayerControls(False)
      PlayerRef.EnableAI(False)
      PlayerRef.ClearExtraArrows()
      PlayerRef.StopCombatAlarm()
      PlayerRef.StopCombat()
      MyPred.SetAlert(False)
      MyPred.EvaluatePackage()
    EndIf
    Parent.ForceRefTo(akNewRef)
    RegisterForSingleUpdate(SCVSet.FollowTimer)
  EndIf
EndFunction

Event OnUpdate()
  ;Find new pred, and fills the alias if applicable
  ;Moves player if the alias has moved too far or left the cell
  ;Note("Updating pred follow")
  If DelayUpdate != 0
    RegisterForSingleUpdate(SCVSet.FollowTimer)
    Return
  EndIf

  Actor CurrentPred = GetActorReference()
  Actor NewPred = SCVLib.findHighestPred(PlayerRef)
  If !NewPred
    Issue("Highest pred function returned none", 1)
  ElseIf NewPred == PlayerRef
    ;Note("Player is the highest actor! Clearing...")
    Clear()
  ElseIf CurrentPred != NewPred
    ;Note("New highest pred! Changing follow.")
    ForceRefTo(NewPred)

    If CurrentPred.IsPlayerTeammate()
      Game.DisablePlayerControls(False, False, False, False, False, True, True, False, 0)
      CurrentPred.SetPlayerControls(False)
      CurrentPred.EnableAI(True)
    EndIf

    If NewPred.IsPlayerTeammate()
      Game.EnablePlayerControls()
      NewPred.SetPlayerControls(True)
      NewPred.EnableAI(True)
    EndIf
    Game.SetCameraTarget(NewPred)
  ElseIf !CurrentPred.GetCurrentLocation().IsSameLocation(PlayerRef.GetCurrentLocation())
    ;Note("Pred moved! Moving Player...")
    PlayerRef.SetPosition(CurrentPred.GetPositionX() + 2000, CurrentPred.GetPositionY()+ 2000, CurrentPred.GetPositionZ())
  ElseIf CurrentPred.GetDistance(PlayerRef) > 3000
    ;Note("Pred moved! Moving Player...")
    PlayerRef.SetPosition(CurrentPred.GetPositionX() + 2000, CurrentPred.GetPositionY()+ 2000, CurrentPred.GetPositionZ())
  EndIf
  If !CameraObject
    CameraObject = CurrentPred.PlaceAtMe(CameraBase, 1, False, False)
  EndIf
  moveCW()
  RegisterForSingleUpdate(SCVSet.FollowTimer)
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
  ;Note("Pred Moved! Moving Player...")
  PlayerRef.MoveTo(GetActorReference(), 2000, 2000)
EndEvent

Event OnCellAttach()
  PlayerRef.MoveTo(GetActorReference(), 2000, 2000)
  ;Note("Pred Moved! Moving Player...")
EndEvent

Function Clear()
  ;Reveals the player and cancels further updates
  ;Note("Alias cleared! Revealing player.")
  Actor CurrentPred = GetActorReference()
  PlayerRef.MoveTo(CurrentPred)
  Game.SetCameraTarget(PlayerRef)
  PlayerRef.SetGhost(False)
  PlayerRef.SetPlayerControls(True)
  Game.EnablePlayerControls()
  If CurrentPred.IsPlayerTeammate()
    CurrentPred.SetPlayerControls(False)
    CurrentPred.EnableAI(True)
  EndIf
  PlayerRef.EnableAI(True)
  PlayerRef.SetAlpha(1, False)
  Parent.Clear()
  UnregisterForUpdate()
EndFunction

Function moveCW()
  CameraPosition = GetPosXYZRotateAroundRef(GetReference(), CameraObject, 0, 0, CameraPosition[2] + 1)
EndFunction

float[] function GetPosXYZRotateAroundRef(ObjectReference akOrigin, ObjectReference akObject, float fAngleX, float fAngleY, float fAngleZ)
  fAngleX = -(fAngleX)
  fAngleY = -(fAngleY)
  fAngleZ = -(fAngleZ)

  float myOriginPosX = akOrigin.GetPositionX()
  float myOriginPosY = akOrigin.GetPositionY()
  float myOriginPosZ = akOrigin.GetPositionZ()

  float fInitialX = akObject.GetPositionX() - myOriginPosX
  float fInitialY = akObject.GetPositionY() - myOriginPosY
  float fInitialZ = akObject.GetPositionZ() - myOriginPosZ

  float fNewX
  float fNewY
  float fNewZ

  ;Objects in Skyrim are rotated in order of Z, Y, X, so we will do that here as well.

  ;Z-axis rotation matrix
  float fVectorX = fInitialX
  float fVectorY = fInitialY
  float fVectorZ = fInitialZ
  fNewX = (fVectorX * Math.cos(fAngleZ)) + (fVectorY * Math.sin(-fAngleZ)) + (fVectorZ * 0)
  fNewY = (fVectorX * Math.sin(fAngleZ)) + (fVectorY * Math.cos(fAngleZ)) + (fVectorZ * 0)
  fNewZ = (fVectorX * 0) + (fVectorY * 0) + (fVectorZ * 1)

  ;Y-axis rotation matrix
  fVectorX = fNewX
  fVectorY = fNewY
  fVectorZ = fNewZ
  fNewX = (fVectorX * Math.cos(fAngleY)) + (fVectorY * 0) + (fVectorZ * Math.sin(fAngleY))
  fNewY = (fVectorX * 0) + (fVectorY * 1) + (fVectorZ * 0)
  fNewZ = (fVectorX * Math.sin(-fAngleY)) + (fVectorY * 0) + (fVectorZ * Math.cos(fAngleY))

  ;X-axis rotation matrix
  fVectorX = fNewX
  fVectorY = fNewY
  fVectorZ = fNewZ
  fNewX = (fVectorX * 1) + (fVectorY * 0) + (fVectorZ * 0)
  fNewY = (fVectorX * 0) + (fVectorY * Math.cos(fAngleX)) + (fVectorZ * Math.sin(-fAngleX))
  fNewZ = (fVectorX * 0) + (fVectorY * Math.sin(fAngleX)) + (fVectorZ * Math.cos(fAngleX))

  ;Return result
  float[] fNewPos = new float[3]
  fNewPos[0] = fNewX + myOriginPosX
  fNewPos[1] = fNewY + myOriginPosY
  fNewPos[2] = fNewZ + myOriginPosZ
  return fNewPos
endFunction



;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Debug Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Bool Function PlayerThought(Actor akTarget, String sMessage1 = "", String sMessage2 = "", String sMessage3 = "", Int iOverride = 0)
  {Use this to display player information. Returns whether the passed actor is
  the player.
  Make sure sMessage1 is 1st person, sMessage2 is 2nd person, sMessage3 is 3rd person
  Make sure at least one is filled: it will default to it regardless of setting
  Use iOverride to force a particular message}

  If akTarget == PlayerRef
    Int Setting = SCLSet.PlayerMessagePOV
    If Setting == -1
      Return True
    EndIf
    If (sMessage1 && Setting == 1) || iOverride == 1
      Debug.Notification(sMessage1)
    ElseIf (sMessage2 && Setting == 2) || iOverride == 2
      Debug.Notification(sMessage3)
    ElseIf (sMessage3 && Setting == 3) || iOverride == 3
      Debug.Notification(sMessage3)
    ElseIf sMessage3
      Debug.Notification(sMessage3)
    ElseIf sMessage1
      Debug.Notification(sMessage1)
    ElseIf sMessage2
      Debug.Notification(sMessage2)
    Else
      Issue("Empty player thought. Skipping...", 1)
    EndIf
    Return True
  Else
    Return False
  EndIf
EndFunction

Bool Function PlayerThoughtDB(Actor akTarget, String sKey, Int iOverride = 0, Int JA_Actors = 0, Int aiActorIndex = -1)
  {Use this to display player information. Returns whether the passed actor is
  the player.
  Pulls message from database; make sure sKey is valid.
  Will add POV int to end of key, so omit it in the parameter}
  Return SCVLib.ShowPlayerThoughtDB(akTarget, sKey, iOverride, JA_Actors, aiActorIndex)
EndFunction

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
