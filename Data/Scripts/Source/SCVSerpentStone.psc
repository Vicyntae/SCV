ScriptName SCVSerpentStone Extends ObjectReference

Actor Property PlayerRef Auto
SCVLibrary Property SCVLib Auto

Event OnActivate(ObjectReference akActionRef)
  If akActionRef == PlayerRef
    Int PlayerData = SCVLib.getTargetData(PlayerRef)
    If SCVLib.isOVPred(PlayerRef, PlayerData)
      Int Level = PlayerRef.GetLevel()
      Int OVLevel = Math.Ceiling(Level / 5)
      JMap.setInt(PlayerData, "SCV_OVLevel", OVLevel)
      Float BaseBonus = 10
      JMap.setFlt(PlayerData, "STBase", JMap.getFlt(PlayerData, "STBase") + BaseBonus)
      Float DigestBonus = 1
      JMap.setFlt(PlayerData, "STDigestionRate", JMap.getFlt(PlayerData, "STDigestionRate") + DigestBonus)
      JMap.setInt(PlayerData, "SCV_IsOVPred", 1)
      SCVLib.checkPredAbilities(PlayerRef)
    EndIf
  EndIf
EndEvent
