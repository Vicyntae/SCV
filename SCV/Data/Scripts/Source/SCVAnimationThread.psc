ScriptName SCVAnimationThread Extends ReferenceAlias
SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
Import Math
Actor Property PlayerRef Auto
String Property DebugName
  String Function Get()
    Return "[SCVAnimationThread" + ThreadID + "] "
  EndFunction
EndProperty
Int DMID = 9
Bool thread_queued
Actor[] Actors
Int JM_AnimInfo
String AnimType
String Situation
String AnimationName
Int CurrentStage
Int JF_ActorBonesChanged
Bool Finished
Int Working
Int Property ThreadID
  Int Function Get()
    Return GetID() + 1
  EndFunction
EndProperty

Function resetThread()
  UnregisterForUpdate()
  Actors = New Actor[1]
  AnimType = ""
  Situation = ""
  JM_AnimInfo = 0
  AnimationName = ""
  CurrentStage = -1
  JF_ActorBonesChanged = 0
  Finished = False
  thread_queued = False
EndFunction

Bool Function queued()
  Return thread_queued
EndFunction

Function setThread(Actor[] akActors, String asType, String asSituation)
  thread_queued = True
  Actors = akActors
  ;Note("Thread being set. Pred = " + Actors[0].GetLeveledActorBase().GetName() + ", Prey = " + Actors[1].GetLeveledActorBase().GetName())
  ;Note("Actor 01" + SCVLib.nameGet(Actors[0]))
  AnimType = asType
  Situation = asSituation
EndFunction

Event OnAnimPrep(Int aiThreadID)
  If aiThreadID == ThreadID
    ;Note("Thread Prep beginning.")
    JM_AnimInfo = getRandomAnim()
    AnimationName = JMap.getStr(JM_AnimInfo, "Name")
  EndIf
EndEvent

Event OnAnimCancel(Int aiThreadID)
  If aiThreadID == ThreadID
    Note("Thread Canceled From Outside!")
    resetThread()
  EndIf
EndEvent

Event OnAnimStart(Int aiThreadID)
  If aiThreadID == ThreadID
    ;Weapon swapping?
    ;Note("Animation Starting!")
    Int i = 100
    If JM_AnimInfo == 0
      Note("JM_AnimInfo not ready yet!")
      While JM_AnimInfo == 0 && i
        Utility.WaitMenuMode(0.1)
        i -= 1
      EndWhile
    EndIf
    If (!i && JM_AnimInfo == 0) || JM_AnimInfo == -1
      Note("No Animations found! Canceling Thread")
      If AnimType == "Oral"
        Actors[0].Say(SCVSet.SCV_SwallowSound)
      ElseIf AnimType == "Anal"
        Actors[0].Say(SCVSet.SCV_TakeInSound)
      EndIf
      If i != 0
        If Actors[i] == PlayerRef
          SCVSet.SCV_FollowPred.ForceRefTo(Actors[0])
        Else
          Actors[i].MoveTo(SCLSet.SCL_HoldingCell)
        EndIf
      EndIf
      resetThread()
      Return
    EndIf
    Note("Animation File Found! Name = " + getAnimationName())
    CurrentStage = -1
    Int j
    Int NumActors = Actors.length
    While j < NumActors
      ActorUtil.AddPackageOverride(Actors[i], SCLSet.SCL_HoldPackage)
      Actors[i].EvaluatePackage()
      If Actors[j] == PlayerRef
        If Game.GetCameraState() == 0
          Game.ForceThirdPerson()
        EndIf
        ;Game.DisablePlayerControls(False, True, False, False, False, False, False, False, 0)
        Game.SetPlayerAIDriven()
      Else
        Actors[j].SetRestrained(True)
        Actors[j].SetDontMove(True)
      EndIf
      j += 1
    EndWhile
    OnUpdate()
  EndIf
EndEvent

Function updateActors(Int Stage)
  Int NumActors = Actors.Length
  Int i
  While i < NumActors
    ;Offsets -------------------------------------------------------------------
    If i != 0
      Int JA_Offsets = getActorOffset(Stage, i)
      If JA_Offsets
        ;Note("Distance="+JIntMap.getFlt(JA_Offsets, 0) +", Orbit="+JIntMap.getFlt(JA_Offsets,1)+", Height="+JIntMap.getFlt(JA_Offsets, 2)+", Direction="+JIntMap.getFlt(JA_Offsets, 3))
        ;Note(Stage + ":"+i+"-Offsets found!")
        ;Actors[i].MoveTo(Actors[0], JArray.getFlt(JA_Offsets, 0) * Math.Sin(Actors[0].GetAngleZ()), JArray.getFlt(JA_Offsets, 1) * Math.Cos(Actors[0].GetAngleZ()), JArray.getFlt(JA_Offsets, 2), False)
        Actors[i].MoveTo(Actors[0], JIntMap.getFlt(JA_Offsets, 0) * sin(Actors[0].GetAngleZ()), JIntMap.getFlt(JA_Offsets, 0) * cos(Actors[0].GetAngleZ()), JIntMap.getFlt(JA_Offsets, 2))
        ;Float[] ActorPosition = GetPosXYZRotateAroundRef(Actors[0], Actors[i], 0, 0, JArray.getFlt(JA_Offsets, 1))
        ;Actors[i].SetPosition(ActorPosition[0], ActorPosition[1], ActorPosition[2])
        Float zOffset = Actors[i].GetHeadingAngle(Actors[0])
        Actors[i].SetAngle(Actors[i].GetAngleX(), Actors[i].GetAngleY(), Actors[i].GetAngleZ() + zOffset + JIntMap.getFlt(JA_Offsets, 3))
      EndIf
    EndIf

    ;Animations ----------------------------------------------------------------
    String AnimEvent = getAnimEvent(Stage, i)
    If AnimEvent
      ;Note(Stage + ":"+i+"-Animation found! AnimEvent="+AnimEvent)
      Debug.SendAnimationEvent(Actors[i], AnimEvent)
    EndIf

    ;Bone Scales ---------------------------------------------------------------
    Int JM_Bones = getBoneScales(Stage, i)
    If !JValue.empty(JM_Bones)
      String BoneKey = JMap.nextKey(JM_Bones)
      If !JF_ActorBonesChanged
        JF_ActorBonesChanged = JValue.retain(JFormMap.object())
      EndIf
      Int JM_BonesChanged = JFormMap.getObj(JF_ActorBonesChanged, Actors[i])
      If !JM_BonesChanged
        JM_BonesChanged = JMap.object()
        JFormMap.setObj(JF_ActorBonesChanged, Actors[i], JM_BonesChanged)
      EndIf
      While BoneKey
        Bool Gender = Actors[i].GetLeveledActorBase().GetSex() as Bool
        If NetImmerse.HasNode(Actors[i], BoneKey, False)
          Note("Scaling Bone " + BoneKey)
          NiOverride.AddNodeTransformScale(Actors[i], False, Gender, BoneKey, "SCVAnim", JMap.getFlt(JM_Bones, BoneKey))
          JMap.setFlt(JM_BonesChanged, BoneKey, JMap.getFlt(JM_Bones, BoneKey))
        EndIf
        NiOverride.UpdateAllReferenceTransforms(Actors[i])
        BoneKey = JMap.nextKey(JM_Bones, BoneKey)
      EndWhile
    EndIf

    ;Body Morphs ---------------------------------------------------------------
    Int JM_Morphs = getMorphs(Stage, i)
    If !JValue.empty(JM_Morphs)
      ;Note(Stage + ":"+i+"-BodyMorphs found!")
      String MorphKey = JMap.nextKey(JM_Morphs)
      While MorphKey
        NiOverride.SetBodyMorph(Actors[i], MorphKey, "SCVAnim", JMap.getFlt(JM_Morphs, MorphKey))
        MorphKey = JMap.nextKey(JM_Morphs, MorphKey)
      EndWhile
      NiOverride.UpdateModelWeight(Actors[i])
    EndIf

    ;SState --------------------------------------------------------------------
    Int SState = getSState(Stage, i)
    If SState > -1
      ;Note(Stage + ":"+i+"-Schlong State found! State = "+SState)
      Debug.SendAnimationEvent(Actors[i], "SOSBend"+SState) ;Set Schlong Position
    EndIf

    ;Mouth State ---------------------------------------------------------------
    Int MouthState = getMouth(Stage, i)
    If MouthState >= 0
      ;Note(Stage + ":"+i+"-Mouth State found!")
      If IsMouthOpen(Actors[i])
        If MouthState == 0
          CloseMouth(Actors[i])
        EndIf
      Else
        If MouthState == 1
          OpenMouth(Actors[i])
        EndIf
      EndIf
    EndIf

    ;Alpha ---------------------------------------------------------------------
    Float Alpha = getSetAlpha(0, i)
    If Alpha >= 0
      ;Note(Stage + ":"+i+"-Alpha State found!")
      Actors[i].SetAlpha(Alpha, False)
    EndIf
    i += 1
  EndWhile
EndFunction

Event OnUpdate()
  If Finished
    Finish()
    Return
  EndIf
  Working += 1
  CurrentStage += 1
  Float Timer = getTimer(CurrentStage)
  Note("Timer = " + Timer)
  If Timer <= 0
    Finished = True
    Timer = 0.1
  EndIf
  RegisterForSingleUpdate(Timer)
  updateActors(CurrentStage)
  String EventName = getEvent(CurrentStage)
  If EventName
    Int Handle = ModEvent.Create(EventName)
    If Handle
      ModEvent.PushForm(Handle, Actors[0])
      ModEvent.pushString(Handle, AnimationName)
      ModEvent.pushInt(Handle, ThreadID)
      ModEvent.pushInt(Handle, CurrentStage)
      ModEvent.send(Handle)
    EndIf
  EndIf
  Working -= 1
EndEvent

Function Finish()
  If Working > 0
    While Working > 0
      Utility.Wait(0.1)
    EndWhile
  EndIf
  Note("Animation Finished! Resetting morphs and bone scales!")
  Actor CurrentActor = JFormMap.nextKey(JF_ActorBonesChanged) as Actor
  While CurrentActor
    Int JM_BonesChanged = JFormMap.getObj(JF_ActorBonesChanged, CurrentActor)
    String BoneName = JMap.nextKey(JM_BonesChanged)
    Bool Gender = CurrentActor.GetLeveledActorBase().GetSex() as Bool
    While BoneName
      Note("Resetting bone for " + SCVLib.nameGet(CurrentActor) +": " + BoneName)
      NiOverride.RemoveNodeTransformScale(CurrentActor, False, Gender, BoneName, "SCVAnim")
      BoneName = JMap.nextKey(JM_BonesChanged, BoneName)
    EndWhile
    NiOverride.UpdateAllReferenceTransforms(CurrentActor)
    CurrentActor = JFormMap.nextKey(JF_ActorBonesChanged, CurrentActor) as Actor
  EndWhile
  JF_ActorBonesChanged = JValue.zeroLifetime(JValue.release(JF_ActorBonesChanged))
  Int i = Actors.length
  While i
    i -= 1
    NiOverride.ClearBodyMorphKeys(Actors[i], "SCVAnim")
    NiOverride.UpdateModelWeight(Actors[i])
    ClearPhoneme(Actors[i])
    CloseMouth(Actors[i])
    ActorUtil.RemovePackageOverride(Actors[i], SCLSet.SCL_HoldPackage)
    Actors[i].EvaluatePackage()
    If Actors[i] == PlayerRef
      ;Game.EnablePlayerControls()
      Game.SetPlayerAIDriven(False)
    Else
      Actors[i].SetRestrained(False)
      Actors[i].SetDontMove(False)
    EndIf
    Debug.SendAnimationEvent(Actors[i], "IdleForceDefaultState")
    If i != 0
      If Actors[i] == PlayerRef
        SCVSet.SCV_FollowPred.ForceRefTo(Actors[0])
      Else
        Actors[i].MoveTo(SCLSet.SCL_HoldingCell)
      EndIf
    EndIf
  EndWhile
  resetThread()
EndFunction

;Debug.SendAnimationEvent(ActorRef, "SOSBend"+Schlong) ;Set Schlong Position

function ClearPhoneme(Actor ActorRef)
	int i
	while i <= 15
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, i, 0)
		i += 1
	endWhile
endFunction

Function OpenMouth(Actor ActorRef) ;Sets Mouth state
	ClearPhoneme(ActorRef)
	ActorRef.SetExpressionOverride(16, 80)
	MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 60)
	;Utility.WaitMenuMode(0.1)
endFunction

function CloseMouth(Actor ActorRef)
	ActorRef.SetExpressionOverride(7, 50)
	MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 0)
	;Utility.WaitMenuMode(0.1)
endFunction

bool function IsMouthOpen(Actor ActorRef)
	return MfgConsoleFunc.GetPhoneme(ActorRef, 1) >= 0.4 || (MfgConsoleFunc.GetExpressionID(ActorRef) == 16 && MfgConsoleFunc.GetExpressionValue(ActorRef) >= 0.7)
endFunction

Float Function getTimer(Int Stage)
  Return JValue.solveFlt(JM_AnimInfo, ".Stages["+Stage+"].Timer")
EndFunction

Int Function getActorOffset(Int Stage, Int Position)
  Return JValue.solveObj(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets")
EndFunction

String Function getAnimEvent(Int Stage, Int Position)
  Return JValue.solveStr(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Animation")
EndFunction

Int Function getBoneScales(Int Stage, Int Position)
  Return JValue.solveObj(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].BoneScales")
EndFunction

Int Function getMorphs(Int Stage, Int Position)
  Return JValue.solveObj(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].BodyMorphs")
EndFunction

Int Function getSState(Int Stage, Int Position)
  Return JValue.solveInt(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].SchlongState", -1)
EndFunction

Int Function getMouth(Int Stage, Int Position)
  Return JValue.solveInt(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].OpenMouth", -1)
EndFunction

Float Function getSetAlpha(Int Stage, Int Position)
  Return JValue.solveFlt(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Alpha", -1)
EndFunction

String Function getEvent(Int Stage)
  Return JValue.solveStr(JM_AnimInfo, ".Stages["+Stage+"].Event")
EndFunction

String Function getAnimationName()
  Return JMap.getStr(JM_AnimInfo, "Name")
EndFunction

Int Function getRandomAnim()
  Int JA_AnimArray = getAnimationArray()
  If !JA_AnimArray
    Return -1
  EndIf
  Int NumAnims = JArray.count(JA_AnimArray)
  Int i
  If NumAnims == 1
    i = 0
  Else
    i = Utility.RandomInt(0, NumAnims - 1)
  EndIf
  Int ReturnAnim = JArray.getObj(JA_AnimArray, i)
  If ReturnAnim
    Return ReturnAnim
  Else
    Return 0
  EndIf
EndFunction

Int Function getAnimationArray()
  Actor akPred = Actors[0]
  Actor akPrey = Actors[1]
  String PredRace = getRaceString(akPred)
  If !PredRace
    Return 0
  EndIf
  String PreyRace = getRaceString(akPrey)
  If !PreyRace
    Return 0
  EndIf
  Int Scale
  Float PredScale = akPred.GetScale() * NetImmerse.GetNodeScale(akPred, "NPC Root [Root]", False)
  Float PreyScale = akPrey.GetScale() * NetImmerse.GetNodeScale(akPrey, "NPC Root [Root]", False)
  Float FinalScale = PredScale / PreyScale
  If FinalScale > 0.8 && FinalScale < 1.2
    Scale = 0
  ElseIf FinalScale > 0.6 && FinalScale < 0.8
    Scale = -1
  ElseIf FinalScale > 0.4 && FinalScale < 0.6
    Scale = -2
  ElseIf FinalScale > 0.2 && FinalScale < 0.4
    Scale = -3
  ElseIf FinalScale < 0.2
    Scale = -4
  ElseIf FinalScale > 1.2 && FinalScale < 1.4
    Scale = 1
  ElseIf FinalScale > 1.4 && FinalScale < 1.6
    Scale = 2
  ElseIf FinalScale > 1.6 && FinalScale < 1.8
    Scale = 3
  ElseIf FinalScale > 1.8 && FinalScale < 2
    Scale = 4
    ;And so on
  Else
    Scale = 0
  EndIf
  Return JDB.solveObj(".SCLExtraData.SCVAnimations." + AnimType + "." + PredRace + "." + PreyRace + "["+Scale+"]." + Situation)
EndFunction

  String Function getRaceString(Actor akTarget)
    Race akRace = akTarget.GetRace()
    If akRace.HasKeyword(SCVSet.ActorTypeNPC)
      Return "Human"
    ElseIf akRace == SCVSet.WolfRace
      Return "Wolf"
    Else
      Return ""
    EndIf
  EndFunction


  ;-----------\
  ;Description \ Author: Chesko
  ;----------------------------------------------------------------
  ;Rotates a point (akObject offset from the center of
  ;rotation (akOrigin) by the supplied degrees fAngleX, fAngleY,
  ;fAngleZ, and returns the new position of the point.

  ;-------------\
  ;Return Values \
  ;----------------------------------------------------------------
  ;               fNewPos[0]      =        The new X position of the point
  ;               fNewPos[1]      =        The new Y position of the point
  ;               fNewPos[2]      =        The new Z position of the point

  ;                        |  1                    0                0     |
  ;Rx(t) =                 |  0                   cos(t)         -sin(t)  |
  ;                        |  0                   sin(t)          cos(t)  |
  ;
  ;                        | cos(t)                0              sin(t)  |
  ;Ry(t) =                 |  0                    1                0     |
  ;                        |-sin(t)                0              cos(t)  |
  ;
  ;                        | cos(t)              -sin(t)            0     |
  ;Rz(t) =                 | sin(t)               cos(t)            0     |
  ;                        |  0                    0                1     |

  ;R * v = Rv, where R = rotation matrix, v = column vector of point [ x y z ], Rv = column vector of point after rotation
  ;Provided angles must follow Bethesda's conventions (CW Z angle for example).
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
    fNewX = (fVectorX * cos(fAngleZ)) + (fVectorY * sin(-fAngleZ)) + (fVectorZ * 0)
    fNewY = (fVectorX * sin(fAngleZ)) + (fVectorY * cos(fAngleZ)) + (fVectorZ * 0)
    fNewZ = (fVectorX * 0) + (fVectorY * 0) + (fVectorZ * 1)

    ;Y-axis rotation matrix
    fVectorX = fNewX
    fVectorY = fNewY
    fVectorZ = fNewZ
    fNewX = (fVectorX * cos(fAngleY)) + (fVectorY * 0) + (fVectorZ * sin(fAngleY))
    fNewY = (fVectorX * 0) + (fVectorY * 1) + (fVectorZ * 0)
    fNewZ = (fVectorX * sin(-fAngleY)) + (fVectorY * 0) + (fVectorZ * cos(fAngleY))

    ;X-axis rotation matrix
    fVectorX = fNewX
    fVectorY = fNewY
    fVectorZ = fNewZ
    fNewX = (fVectorX * 1) + (fVectorY * 0) + (fVectorZ * 0)
    fNewY = (fVectorX * 0) + (fVectorY * cos(fAngleX)) + (fVectorZ * sin(-fAngleX))
    fNewZ = (fVectorX * 0) + (fVectorY * sin(fAngleX)) + (fVectorZ * cos(fAngleX))

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
