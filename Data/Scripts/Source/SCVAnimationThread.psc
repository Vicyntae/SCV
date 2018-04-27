ScriptName SCVAnimationThreadNOTDONE Extends Quest
SCVLibrary Property SCVLib Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto
String Property DebugName
  String Function Get()
    Return "[SCVAnimationThread" + ThreadID + "] "
  EndFunction
EndProperty
Int DMID = 9
Actor Property PlayerRef Auto
Int AnimEntry
Actor MyActor
Actor PrimeActor  ;used for positioning
Int CurrentStage
Bool Gender
Int JM_BonesChanged
Bool thread_queued
Int Working = 0
SCVAnimationBase AnimInfo
Float PositionX
Float PositionY
Float PositionZ

Bool Function queued()
  Return thread_queued
EndFunction

Function setThread(Actor[] akActors, Int aiEntry, Int aiActorID)
  thread_queued = True
  JA_StageList = JIntMap.getObj(JMap.getObj(aiEntry, "AnimTimers"), aiActorID)
  MyActor = akActors[aiActorID]
  Int JM_AnimInfo = JIntMap.getObj(JMap.getObj(aiEntry, "AnimEventInfo"), aiActorID)
  AnimEvent = JMap.getStr(JM_AnimInfo, "AnimEventName")
  PositionX = JMap.getFlt(JM_AnimInfo, "X")
  PositionY = JMap.getFlt(JM_AnimInfo, "Y")
  PositionZ = JMap.getFlt(JM_AnimInfo, "Z")
  PrimeActor = akActors[JMap.getInt(JM_AnimInfo, "PrimaryActor")]
  Gender = MyActor.GetLeveledActorBase().GetSex() as Bool
EndFunction

Event OnAnimStart()
  ;Weapon swapping?
  If MyActor != PrimeActor
    MyActor.MoveTo(PrimeActor, PositionX * Math.Sin(PrimeActor.GetAngleZ()), PositionY * Math.Cos(PrimeActor.GetAngleZ()), PrimeActor.GetHeight() + PositionZ)
  EndIf
  Debug.SendAnimationEvent(MyActor, AnimEvent)

  OnUpdate()
  UnregisterForAllModEvents()
EndEvent

Function Finish()
  If Working > 0
    While Working > 0
      Utility.Wait(0.1)
    EndWhile
  EndIf
  String BoneName = JMap.nextKey(JM_BonesChanged)
  While BoneName
    RemoveNodeTransformScale(MyActor, False, Gender, BoneName, "SCVAnim")
    NiOverride.UpdateNodeTransform(MyActor, False, Gender, BoneName)
    BoneName = JMap.nextKey(JM_BonesChanged, BoneName)
  EndWhile
  NiOverride.ClearBodyMorphKeys(MyActor, "SCVAnim")
  MyActor = None
  AnimEntry = 0
  Gender = False
  CurrentStage = 0
  PositionX = 0
  PositionY = 0
  PositionZ = 0
  PrimaryActor = None
  JM_BonesChanged = 0
  thread_queued = False
EndFunction

Event OnUpdate()
  Int JM_Event = JArray.getObj(JA_StageList, CurrentStage)
  CurrentStage += 1
  If !JM_Event
    Finish()
    Return
  Else
    RegisterForSingleUpdate(JMap.getFlt(JM_Event, "Time"))
  EndIf
  Working += 1

  Int JM_Bone = JMap.getObj(JM_Event, "BoneScales")
  If !JValue.empty(JM_Bone)
    String BoneName = JMap.nextKey(JM_Bone)
    While BoneName
      If NetImmerse.HasNode(MyActor, BoneName, False)
        NiOverride.AddNodeTransformScale(MyActor, False, Gender, BoneName, "SCVAnim", JMap.getFlt(JM_Bone, BoneName))
        NiOverride.UpdateNodeTransform(MyActor, False, Gender, BoneName)
        JMap.setStr(JM_BonesChanged, BoneName, "SCVAnim")
      EndIf
      BoneName = JMap.nextKey(JM_Bone, BoneName)
    EndWhile
  EndIf

  Int JM_Morph = JMAp.getObj(JM_Event, "Bodymorphs")
  If !JValue.empty(JM_Morph)
    String MorphName = JMap.nextKey(JM_Morph)
    While MorphName
      NiOverride.SetBodyMorph(MyActor, MorphName,  "SCVAnim", JMap.getFlt(JM_Morph, MorphName))
      MorphName = JMap.nextKey(JM_Morph, MorphName)
    EndWhile
    NiOverride.UpdateModelWeight(MyActor)
  EndIf

  Working -= 1
EndEvent

;Debug.SendAnimationEvent(ActorRef, "SOSBend"+Schlong) ;Set Schlong Position

;/function OpenMouth(Actor ActorRef) global Sets Mouth state
	ClearPhoneme(ActorRef)
	ActorRef.SetExpressionOverride(16, 80)
	MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 60)
	Utility.WaitMenuMode(0.1)
endFunction

function CloseMouth(Actor ActorRef) global
	ActorRef.SetExpressionOverride(7, 50)
	MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 0)
	Utility.WaitMenuMode(0.1)
endFunction

bool function IsMouthOpen(Actor ActorRef) global
	return GetPhoneme(ActorRef, 1) >= 0.4 || (GetExpression(ActorRef, true) == 16.0 && GetExpression(ActorRef, false) >= 0.7)
endFunction;/
