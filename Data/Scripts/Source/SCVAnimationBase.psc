ScriptName SCVAnimationBase
Int JM_AnimInfo
;*******************************************************************************
;Stage Info
;*******************************************************************************
Float Function getActorOffsetX(Int Stage, Int Position)
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
  Float[] OffsetArray = New Float[3]
  OffsetArray[0] = JArray.getFlt(JA_Offsets, 0)
  OffsetArray[1] = JArray.getFlt(JA_Offsets, 1)
  OffsetArray[2] = JArray.getFlt(JA_Offsets, 2)
  Return OffsetArray
EndFunction
  
Function setActorOffset(Int Stage, Int Position, Float OffsetX, Float OffsetY, Float OffsetZ) ;Calculated from Primary Actor
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[0]", OffsetX, True)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[1]", OffsetY, True)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Offsets[2]", OffsetZ, True)
EndFunction

Function setAnimation(Int Stage, Int Position, String AnimEvent)
  JValue.solveStrSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Animation", AnimEvent, True)
EndFunction

Function setTimer(Int Stage, Float Time)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Timer", Time, True)
EndFunction

Function setBoneScale(Int Stage, Int Position, String Bone, Float Scale)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].BoneScales."+Bone, Scale, True)
EndFunction

Function setMorph(Int Stage, Int Position, String Morph, Float Value)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].BodyMorphs."+Morph, Value, True)
EndFunction

Function setSchlongState(Int Stage, Int Position, Int SState)
  JValue.solveIntSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].SchlongState", SState, True)
EndFunction

Function setOpenMouth(Int Stage, Int Position, Int Mouth) ;Only 1 or 0
  JValue.solveIntSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].OpenMouth", Mouth, True)
EndFunction


Function setAlpha(Int Stage, Int Position, Float Alpha)
  JValue.solveFltSetter(JM_AnimInfo, ".Stages["+Stage+"].Positions["+Position+"].Alpha", Alpha, True)
EndFunction

;*******************************************************************************
;Position Info
;*******************************************************************************
Function setGenderReqs(Int Position, Int Gender)  ;0 = Males, 1 = Females, -1 = No requirements
  JValue.solveIntSetter(JM_AnimInfo, ".PositionInfo["+Position+"].ReqGender" + Gender)
EndFunction

Function setRaceReqs(Int Position, Race ReqRace)
  JValue.solveFormSetter(JM_AnimInfo, ".PositionInfo["+Position+"].ReqRace" + ReqRace)
EndIf

Function setScaleReqs(Int Position, Float ScaleMin, Float ScaleMax) ;Value in relation to primary (0)
  JValue.solveFltSetter(JM_AnimInfo, ".PositionInfo["+Position+"].ScaleMin", ScaleMin, True)
  JValue.solveFltSetter(JM_AnimInfo, ".PositionInfo["+Position+"].ScaleMax", ScaleMax, True)
EndFunction

Function setPredType(Int Position, Int PredType) ; 0 = Bystander, 1 = Prey, 2 = Oral, 3 = Anal
  JValue.solveIntSetter(JM_AnimInfo, ".PositionInfo["+Position+"].PredTypes["+PredType+"]", 1, True)
EndFunction

;Convenience function to set all pred types of actors
Function setPredTypes(Int Position, Bool[] PredTypes)
  Int i = PredTypes.Length
  While i
    i -= 1
    If PredTypes[i]
      setPredType(Position, i)
    EndIf
  EndWhile
EndFunction


Function setNumPosition(Int NumPositions)
  JMap.setInt(JM_AnimInfo, "NumPositions", NumPositions)
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
EndFunction
