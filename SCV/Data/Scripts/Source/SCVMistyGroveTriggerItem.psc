ScriptName SCVMistyGroveTriggerItem Extends ObjectReference
Actor Property PlayerRef Auto
SCVLibrary Property SCVLib Auto
GlobalVariable Property SCV_EnableWisps Auto
Quest Property SCV_Quest_FindMistyWisp Auto
Event OnActivate(ObjectReference akActionRef)
  If akActionRef == PlayerRef
    Int PlayerData = SCVLib.getTargetData(PlayerRef)
    If !SCVLib.isAVPred(PlayerRef, PlayerData)
      Int Level = PlayerRef.GetLevel()
      Int AV = Math.Ceiling(Level / 5)
      JMap.setInt(PlayerData, "SCV_AVLevel", AV)
      Int BaseBonus = 5
      JMap.setInt(PlayerData, "WF_BasementStorage", JMap.getInt(PlayerData, "WF_BasementStorage") + BaseBonus)
      Float DigestBonus = 1
      JMap.setFlt(PlayerData, "WF_SolidBreakDownRate", JMap.getFlt(PlayerData, "WF_SolidBreakDownRate") + DigestBonus)
      JMap.setInt(PlayerData, "SCV_IsAVPred", 1)
      SCVLib.checkPredAbilities(PlayerRef)
      Debug.MessageBox("You feel the power of debauchery flow through you, along with a curious sensation...")
      SCV_Quest_FindMistyWisp.CompleteQuest()
    EndIf
  EndIf
EndEvent
