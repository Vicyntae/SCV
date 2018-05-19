ScriptName SCVAnimCreate Extends Quest
Int Function createAnimationBase(String AnimationName, String asType, String asPredRace, String asPreyRace, Int aiSizeRank, String asSituation) Global
  ;Debug.Notification("Creating Animation " + AnimationName)
  Int Anim = JMap.object()
  JMap.setStr(Anim, "Name", AnimationName)
  Int JA_Anims = JDB.solveObj(".SCLExtraData.SCVAnimations." + asType + "." + asPredRace + "." + asPreyRace + "[" + aiSizeRank + "]." + asSituation)
  If !JA_Anims
    JA_Anims = JArray.object()
    JDB.solveObjSetter(".SCLExtraData.SCVAnimations." + asType + "." + asPredRace + "." + asPreyRace + "[" +aiSizeRank+"]." + asSituation, JA_Anims, True)
  EndIf
  JArray.addObj(JA_Anims, Anim)
  Return Anim
EndFunction

;*******************************************************************************
;Stage Info
;*******************************************************************************


Function setActorOffset(Int JM_AnimInfo, Int Stage, Int Position, Float Distance, Float OrbitDegree, Float Height, Float Facing)  Global;Calculated from Primary Actor
  ;0 = Distance from target, 1 = Orbit Rotation around target (0=In front of), 2 = Height offset from target, 3 = Facing Direction relative to target (0 = Facing same direction)
  ;Debug.Notification("Adding Actor offset to " + JMap.getStr(JM_AnimInfo, "Name") + ", " + OffsetX+"/"+OffsetY+"/"+OffsetZ+"/"+OffsetrZ)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[0]", Distance, True)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[1]", OrbitDegree, True)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[2]", Height, True)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[3]", Facing, True)
  ;Debug.Notification("OffsetX=" + JValue.solveFlt(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[0]"))
EndFunction

Function setAnimation(Int JM_AnimInfo, Int Stage, Int Position, String AnimEvent) Global
  ;Debug.Notification("Adding Animation Event to " + JMap.getStr(JM_AnimInfo, "Name"))
  JValue.solveStrSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Animation", AnimEvent, True)
  ;Debug.Notification("Animation Event = "+JValue.solveStr(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Animation"))
EndFunction

Function setTimer(Int JM_AnimInfo, Int Stage, Float Time) Global
  ;Debug.Notification("Adding Timer to " + JMap.getStr(JM_AnimInfo, "Name"))
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Timer", Time, True)
  ;Debug.Notification("Stage "+Stage+" Timer=" + JValue.solveFlt(JM_AnimInfo, ".Stages["+Stage+"].Timer"))
EndFunction

Function setBoneScale(Int JM_AnimInfo, Int Stage, Int Position, String Bone, Float Scale) Global
  Int JM_BoneScales = JValue.solveObj(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].BoneScales")
  If !JM_BoneScales
    JM_BoneScales = JMap.object()
    JValue.solveObjSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].BoneScales", JM_BoneScales, True)
  EndIf
  JMap.setFlt(JM_BoneScales, Bone, Scale)
EndFunction

Function setMorph(Int JM_AnimInfo, Int Stage, Int Position, String Morph, Float Value) Global
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].BodyMorphs."+Morph, Value, True)
EndFunction

Function setEvent(Int JM_AnimInfo, Int Stage, String asEventName) Global
  JValue.solveStrSetter(JM_AnimInfo, ".Stages["+Stage+"].Event", asEventName, True)
EndFunction

Function setSchlongState(Int JM_AnimInfo, Int Stage, Int Position, Int SState) Global
  JValue.solveIntSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].SchlongState", SState, True)
EndFunction

Function setOpenMouth(Int JM_AnimInfo, Int Stage, Int Position, Int Mouth) Global ;Only 1 or 0
  JValue.solveIntSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].OpenMouth", Mouth, True)
EndFunction

Function setAlpha(Int JM_AnimInfo, Int Stage, Int Position, Float Alpha) Global
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Alpha", Alpha, True)
EndFunction

;*******************************************************************************
;Position Info
;*******************************************************************************

Function setNumPosition(Int JM_AnimInfo, Int NumPositions) Global
  JMap.setInt(JM_AnimInfo, "NumPositions", NumPositions)
EndFunction

;/Float Function getActorOffsetX(Int Stage, Int Position)
  Return JValue.solveFlt(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[0]")
EndFunction

Float Function getActorOffsetY(Int Stage, Int Position)
  Return JValue.solveFlt(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[1]")
EndFunction

Float Function getActorOffsetZ(Int Stage, Int Position)
  Return JValue.solveFlt(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[2]")
EndFunction

Float[] Function getActorOffset(Int Stage, Int Position)
  Int JA_Offsets = JValue.solveObj(JM_AnimInfo, ".Stages["+Stage+"].Position["+Position+"].Offsets")
  Float[] OffsetArray = New Float[4]
  OffsetArray[0] = JArray.getFlt(JA_Offsets, 0)
  OffsetArray[1] = JArray.getFlt(JA_Offsets, 1)
  OffsetArray[2] = JArray.getFlt(JA_Offsets, 2)
  OffsetArray[2] = JArray.getFlt(JA_Offsets, 3)
  Return OffsetArray
EndFunction

Int Function getNumPredTypes(Int PredType)
  Return JValue.evalLuaInt(JMap.getObj(JM_AnimInfo, "PositionInfo"), "return jc.count(jobject, function(x) return x.PredTypes["+PredType+"] == 1, '.ReqGender')", -1)
EndFunction

Int Function FemaleCount()
  Return JValue.evalLuaInt(JMap.getObj(JM_AnimInfo, "PositionInfo"), "return jc.count(jobject, function(x) return x.ReqGender == 1, '.ReqGender')", -1)
EndFunction

Int Function MaleCount()
  Return JValue.evalLuaInt(JMap.getObj(JM_AnimInfo, "PositionInfo"), "return jc.count(jobject, function(x) return x.ReqGender == 0, '.ReqGender')", -1)
EndFunction

Int Function UndefinedGenderCount()
  Return JValue.evalLuaInt(JMap.getObj(JM_AnimInfo, "PositionInfo"), "return jc.count(jobject, function(x) return x.ReqGender == -1, '.ReqGender')", -1)
EndFunction

Int Function AvailableFemaleCount()
  Return JValue.evalLuaInt(JMap.getObj(JM_AnimInfo, "PositionInfo"), "return jc.count(jobject, function(x) return x.ReqGender == 1 or x.ReqGender == -1, '.ReqGender')", -1)
EndFunction

Int Function AvailableMaleCount()
  Return JValue.evalLuaInt(JMap.getObj(JM_AnimInfo, "PositionInfo"), "return jc.count(jobject, function(x) return x.ReqGender == 0 or x.ReqGender == -1, '.ReqGender')", -1)
EndFunction/;
