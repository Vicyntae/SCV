ScriptName SCVModConfig Extends SCLModConfig
Int DMID = 5
Int ScriptVersion = 1
;/Function CheckSCLVersion()
EndFunction/;

SCVDatabase Property SCVData Auto
SCVSettings Property SCVSet Auto
SCVLibrary Property SCVLib Auto

Form[] EssentialPreyList
;Events ************************************************************************
Event OnPageReset(string a_page)
  If !MCMInitialized
    AddTextOptionST("StartMod_T", "Start SCL", "")
  ElseIf a_page == "$Actor Information"
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddMenuOptionST("SelectedActor_M", "$Actor", SelectedActorName);0
    If SelectedActor
      Int AD = SelectedData
      Actor S = SelectedActor
      AddToggleOptionST("TriggerVomit_TOG", "$Induce Vomiting", TriggerVomit);2
      If VomitTarget
        AddTextOptionST("VomitTargetDisplay_T", "$Vomit Target", VomitTarget.GetLeveledActorBase().GetName());1
        If TriggerVomit && SCLSet.DebugEnable
          AddToggleOptionST("VomitEverything_TOG", "$Remove Everything", TriggerVomitEverything);3
        Else
          AddEmptyOption()
          TriggerVomitEverything = False
        EndIf
      EndIf

      SetCursorFillMode(TOP_TO_BOTTOM)
      If SCLSet.DebugEnable
        AddSliderOptionST("EditBase_S", "$Base Capacity", JMap.getFlt(AD, "STBase"), "{1} Units")  ;4
        AddSliderOptionST("EditStretch_S", "$Stretch", JMap.getFlt(AD, "STStretch"), "Base x {1}")
        AddTextOptionST("AdjBaseDisplay_T", "$Adjusted Base", SCLib.getAdjBase(S))
        AddSliderOptionST("EditDigestRate_S", "$Digestion Rate", JMap.getFlt(AD, "STDigestionRate"), "{1} Units per Hour")
        AddSliderOptionST("EditGluttony_S", "$Gluttony", JMap.getFlt(SelectedData, "SCLGluttony"), "{0}")
      Else
        AddTextOptionST("DisplayBase_T", "$Base Capacity", SCLib.roundFlt(JMap.getFlt(AD, "STBase"), 1))
        AddTextOptionST("DisplayStretch_T", "$Stretch", SCLib.roundFlt(JMap.getFlt(AD, "STStretch"), 1))
        AddTextOptionST("AdjBaseDisplay_T", "$Adjusted Base", SCLib.getAdjBase(S))
        AddTextOptionST("DisplayDigestRate_T", "$Base Digestion Rate", SCLib.roundFlt(JMap.getFlt(AD, "STDigestionRate"), 1))
        AddTextOptionST("DisplayGluttony_T", "$Gluttony", JMap.getFlt(SelectedData, "SCLGluttony"))
      EndIf
      AddTextOptionST("DisplayNumStored_T", "$Num Items Stored", SCLib.countItemTypes(SelectedActor, 2, True))
      AddTextOptionST("DisplayFullness_T", "$Fullness", JMap.getFlt(AD, "STFullness"))  ;12
      AddTextOptionST("DisplayMax_T", "$Max Capacity", SCLib.getMax(S)) ;14
      AddTextOptionST("DisplaySolidIllness", "$Illness Level", JMap.getInt(SelectedData, "WF_SolidIllnessLevel"))
      If SCLSet.DebugEnable
        AddSliderOptionST("WF_EditMaxStorage_S", "$Set Max Num Items To Stow", SCLib.WF_getSolidMaxNumItems(SelectedActor))
      Else
        AddTextOptionST("WF_DisplayMaxStorage_T", "$Max Num Items To Stow", SCLib.WF_getSolidMaxNumItems(SelectedActor))
      EndIf
      AddTextOptionST("WF_DisplayMaxInsert_T", "$Max Insertable Size", SCLib.WF_getSolidMaxInsert(SelectedActor, SelectedData))
      If SelectedActor == PlayerRef && SCLib.getCurrentPerkLevel(SelectedActor, "WF_BottomsUp") >= 1
        AddToggleOptionST("SetAutoDestination_TOG", "$Auto-Send To Colon", SCLSet.PlayerAutoDestination)
      EndIf
      AddTextOptionST("DisplayNumStowedItems_T", "$Num Items Stowed Away", SCLib.countItemTypes(SelectedActor, 4, True))
      AddTextOptionST("DisplaySolidFullness_T", "$Solid Fulless", SCLib.roundFlt(SCLib.WF_getTotalSolidFullness(SelectedActor, SelectedData), 1))
  		;AddTextOptionST("DisplayTotalDigest_T", "Total Digested Food", JMap.getFlt(AD, "STTotalDigestedFood")) ;16
  		AddMenuOptionST("DisplayStomachContents_M", "$Show Stomach Contents", "") ;18

      SetCursorPosition(5)
      If SCLSet.DebugEnable
        AddSliderOptionST("EditResistLevel_S", "Resistance Level", SCVlib.getResLevel(S, AD), "{0}") ;9
      Else
        AddTextOptionST("DisplayResistLevel_T", "Resistance Level", SCVlib.getResLevel(S, AD))
      EndIf

      AddTextOptionST("DisplayResistExp_T", "Resistance Exp", SCVLib.getResEXP(S, AD) + "/" + SCVLib.getResEXPThreshold(SCVLib.getResLevel(S, AD))) ;11
      AddEmptyOption()

      Bool isPred
      Bool isOVPred = SCVLib.isOVPred(S, AD)
      If (isOVPred && SCVLib.isOVPred(PlayerRef)) || SCLSet.DebugEnable ;Prevents players from viewing stats if they haven't discovered it yet.
        If SCLSet.DebugEnable
          AddTextOptionST("DisplayIsOVPred_T", "Set Oral Predator Status", isOVPred) ;4
          AddSliderOptionST("EditOVLevel_S", "Oral Vore Level", SCVLib.getOVLevel(S, AD), "{0}")  ;8
          AddSliderOptionST("EditOVLevelExtra_S", "Extra Oral Vore Level", SCVLib.getOVLevelExtra(S, AD), "{0}")  ;10
        Else
          AddHeaderOption("Oral Pred Stats")
          AddTextOptionST("DisplayOVLevel_T", "Oral Vore Level", SCVLib.getOVLevel(S, AD))
          AddTextOptionST("DisplayOVLevelExtra_T", "Extra Oral Vore Level", SCVLib.getOVLevelExtra(S, AD))
        EndIf
        AddTextOptionST("DisplayOVExp_T", "Oral Vore Exp", SCVLib.getOVEXP(S, AD) + "/" + SCVLib.getOVEXPThreshold(SCVLib.getOVLevel(S,AD)))  ;12
        AddEmptyOption()
        isPred = True
      EndIf

      Bool isAVPred = SCVLib.isAVPred(S, AD)
      If (isAVPred && SCVLib.isAVPred(PlayerRef)) || SCLSet.DebugEnable
        If SCLSet.DebugEnable
          AddTextOptionST("DisplayIsAVPred_T", "Set Anal Predator Status", isAVPred) ;4
          AddSliderOptionST("EditAVLevel_S", "Anal Vore Level", SCVLib.getAVLevel(S, AD), "{0}")  ;8
          AddSliderOptionST("EditAVLevelExtra_S", "Extra Anal Vore Level", SCVLib.getAVLevelExtra(S, AD), "{0}")  ;10
        Else
          AddHeaderOption("Anal Pred Stats")
          AddTextOptionST("DisplayAVLevel_T", "Anal Vore Level", SCVLib.getAVLevel(S, AD))
          AddTextOptionST("DisplayAVLevelExtra_T", "Extra Anal Vore Level", SCVLib.getAVLevelExtra(S, AD))
        EndIf
        AddTextOptionST("DisplayAVExp_T", "Anal Vore Exp", SCVLib.getAVEXP(S, AD) + "/" + SCVLib.getAVEXPThreshold(SCVLib.getAVLevel(S,AD)))  ;12
        AddEmptyOption()
        isPred = True
      EndIf

      If isPred
        AddTextOptionST("DisplayPredLevel", "Overall Predator Level", SCVLib.calculatePredLevel(S, AD))
      EndIf

    Else
      AddTextOptionST("ChooseActorMessage_T", "$Choose an actor.", "")
    Endif
  ElseIf a_page == "$Actor Perks"
    JI_PerkIndex = JValue.releaseAndRetain(JI_PerkIndex, JIntMap.object())
    JM_PerkValues = JValue.releaseAndRetain(JM_PerkValues, JMap.object())
    If !JM_SelectedPerkLevel
      JM_SelectedPerkLevel = JValue.retain(JMap.object())
    EndIf
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddMenuOptionST("SelectedActor_M", "Actor", SelectedActorName);0
    AddEmptyOption()
    If SelectedActor
      Actor S = SelectedActor
      String asPerkID = JMap.nextKey(SCLSet.JM_PerkIDs)
      While asPerkID
        addPerkOption(SelectedActor, asPerkID)
        asPerkID = JMap.nextKey(SCLSet.JM_PerkIDs, asPerkID)
      EndWhile
    Else
      AddTextOptionST("ChooseActorMessage_T", "$Choose an actor.", "")
    Endif
  ElseIf a_page == "$Actor Records"
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddMenuOptionST("SelectedActor_M", "$Actor", SelectedActorName);0
    If SelectedActor
      AddTextOptionST("DisplayTotalDigest_T", "$Total Digested Food", JMap.getFlt(SelectedData, "STTotalDigestedFood")) ;2
      AddTextOptionST("DisplayTotalTimesVomited", "$Total Times Vomited", JMap.getInt(SelectedData, "SCLAllowOverflowTracking")) ;4
      AddTextOptionST("DisplayHighestFullness", "$Highest Fullness Reached", JMap.getFlt(SelectedData, "SCLHighestFullness")) ; 6
      AddTextOptionST("DisplayTotalBrokenDown_T", "$Total Broken Down Food", JMap.getFlt(SelectedData, "WF_TotalBrokenDown")) ;2
      Int Bottoms = SCLib.getCurrentPerkLevel(SelectedActor, "WF_BottomsUp")
      If Bottoms >= 1
        AddTextOptionST("DisplayTotalTempBoostsGained_T", "$Total Temporary Boosts Gained", JMap.getInt(SelectedData, "WF_TotalTempBoostsGained"))
      EndIf
      If Bottoms >= 4
        AddTextOptionST("DisplayTotalPermBoostsGained_T", "$Total Permanent Boosts Gained", JMap.getInt(SelectedData, "WF_TotalPermBoostsGained"))
      EndIf
      Int Refine = SCLib.getCurrentPerkLevel(SelectedActor, "WF_RearRefinery")
      If Refine > 1
        AddTextOptionST("DisplayTotalItemsRefined_T", "$Total Items Refined", JMap.getInt(SelectedData, "WF_TotalRefinedItems"))
      EndIf

      AddTextOptionST("DisplayCurrentDigestValue", "Current Weight", SCVLib.genDigestValue(SelectedActor, True))
      AddTextOptionST("DisplayNumAvoidVore", "Avoided Being Eaten", JMap.getInt(SelectedData, "SCV_StrokeOfLuckAvoidVore"))
      Int LuckNum = JMap.getInt(SelectedData, "SCV_StrokeOfLuckActivate")
      If LuckNum
        AddTextOptionST("DisplayStrokesOfLuck", "Strokes of Luck", LuckNum)
      Else
        AddTextOptionST("UnknownDisplay", "?????", "?????")
      EndIf
      Int DragonGems = JMap.getInt(SelectedData, "SCV_DragonGemsConsumed")
      If DragonGems
        AddTextOptionST("DisplayNumDragonGems", "Dragon Gems Consumed", DragonGems)
      Else
        AddTextOptionST("UnknownDisplay", "?????", "?????")
      EndIf
      AddMenuOptionST("EssentialPreyList_M", "$Essential Prey List", "")
      SetCursorPosition(3)
      AddTextOptionST("DisplayNumPreyEaten", "Devoured and Finished Prey", JMap.getInt(SelectedData, "SCV_NumPreyEaten"))  ;3
      AddTextOptionST("DisplayNumOVPreyEaten", "Swallowed and Finished Prey", JMap.getInt(SelectedData, "SCV_NumOVPreyEaten"))  ;5
      AddTextOptionST("DisplayNumAVPreyEaten", "Taken in and Finished Prey", JMap.getInt(SelectedData, "SCV_NumAVPreyEaten"))  ;5
      AddTextOptionST("DisplayNumHumansEaten", "Humans Devoured", JMap.getInt(SelectedData, "SCV_NumHumansEaten"))  ;7
      AddTextOptionST("DisplayNumDragonsEaten", "Dragons Devoured", JMap.getInt(SelectedData, "SCV_NumDragonsEaten"))  ;9
      AddTextOptionST("DisplayNumDwarvenEaten", "Dwarven Automatons Devoured", JMap.getInt(SelectedData, "SCV_NumDwarvenEaten"))  ;11
      AddTextOptionST("DisplayNumGhostsEaten", "Ghosts Devoured", JMap.getInt(SelectedData, "SCV_NumGhostsEaten"))  ;13
      AddTextOptionST("DisplayNumUndeadEaten", "Undead Devoured", JMap.getInt(SelectedData, "SCV_NumUndeadEaten"))  ;15
      AddTextOptionST("DisplayNumDaedraEaten", "Daedra Devoured", JMap.getInt(SelectedData, "SCV_NumDaedraEaten"))  ;17
      AddTextOptionST("DisplayNumImportantEaten", "Important Prey Devoured", JMap.getInt(SelectedData, "SCV_NumImportantEaten"))  ;19
    Else
      AddTextOptionST("ChooseActorMessage_T", "$Choose an actor.", "")
    EndIf
  ElseIf a_page == "$Settings"
    SetCursorFillMode(LEFT_TO_RIGHT)
    SetCursorPosition(0)
    AddHeaderOption("General Settings")
    AddHeaderOption("")
    AddToggleOptionST("EnableFollower_TOG", "$Enable Follower Tracking", SCLSet.EnableFollowerTracking)
    AddToggleOptionST("EnableUnique_TOG", "$Enable Unique Actor Tracking", SCLSet.EnableUniqueTracking)
    AddToggleOptionST("EnableNPC_TOG", "$Enable NPC Tracking", SCLSet.EnableNPCTracking)
    AddSliderOptionST("MaxNumTracking_S", "$Max Num Actors Tracked", SCLSet.MaxActorTracking, "{0} Actors")

    AddToggleOptionST("EnableMPreds_TOG", "Enable Male NPC Predators", SCVSet.EnableMPreds)
    AddToggleOptionST("EnableFPreds_TOG", "Enable Female NPC Predators", SCVSet.EnableFPreds)

    AddToggleOptionST("EnableMTeamPreds_TOG", "Enable Male Teammate Predators", SCVSet.EnableMTeamPreds)
    AddToggleOptionST("EnableFTeamPreds_TOG", "Enable Female Teammate Predators", SCVSet.EnableFTeamPreds)

    AddToggleOptionST("EnablePlayerEssential_TOG", "Enable Player Devouring Essential NPCs", SCVSet.EnablePlayerEssentialVore)
    AddToggleOptionST("EnableEssential_TOG", "Enable Devouring Essential NPCs", SCVSet.EnableEssentialVore)

    AddSliderOptionST("OVPredPercent_S", "Oral Predator Percentage", SCVSet.OVPredPercent, "{0} Percent")
    AddSliderOptionST("AVPredPercent_S", "Anal Predator Percentage", SCVSet.AVPredPercent, "{0} Percent")

    AddHeaderOption("Struggle Settings")
    AddEmptyOption()
    AddSliderOptionST("StruggleMod_S", "Struggle Modifier", SCVSet.StruggleMod, "x{1}")
    AddSliderOptionST("DamageMod_S", "Damage Modifier", SCVSet.DamageMod, "x{1}")

    AddHeaderOption("$Digestion Settings")
    AddHeaderOption("")
    AddSliderOptionST("GlobalDigest_S", "$Global Digestion Rate", SCLSet.GlobalDigestMulti, "x{1}")
    AddSliderOptionST("UpdateRate_S", "$Update Rate", SCLSet.UpdateRate, "Every {1} Seconds")
    AddSliderOptionST("UpdateDelay_S", "$Update Delay", SCLSet.UpdateDelay, "Pause for {1} Seconds")
    AddSliderOptionST("WF_SolidIllnessBuildUpDecrease_S", "Build Up Decrease Rate", SCLSet.IllnessBuildUpDecrease, "{1}/hr")

    AddHeaderOption("Expand Settings") ;7
    AddHeaderOption("")
    AddSliderOptionST("DefaultExpandTimer_S", "$Global Expand Timer", SCLSet.DefaultExpandTimer, "Every {1} hours")
    AddSliderOptionST("DefaultExpandBonus_S", "$Global Expand Bonus", SCLSet.DefaultExpandBonus, "{1} units")

    AddHeaderOption("Inflation Settings");11
    AddHeaderOption("")
    AddMenuOptionST("BellyInflateMethod_M", "$Belly Method", SCLSet.InflateMethodArray[SCLSet.BellyInflateMethod])
    AddSliderOptionST("MinBelly_S", "$Belly Minimum Size", SCLSet.BellyMin, "{1}")
    AddSliderOptionST("MaxBelly_S", "$Belly Maximum Size", SCLSet.BellyMax, "{1}")
    AddSliderOptionST("MultiBelly_S", "$Belly Multiplier", SCLSet.BellyMulti, "x{1}")
    AddSliderOptionST("HighScaleBelly_S", "$High-Value Belly Scale", SCLSet.BellyHighScale, "{2}")
    AddSliderOptionST("CurveBelly_S", "$Belly Curve", SCLSet.BellyCurve, "{2}")
    AddSliderOptionST("IncBelly_S", "$Belly Increment", SCLSet.BellyIncr, "{1}") ;17
    AddSliderOptionST("DynEquipModifier_S", "$Dynamic Equipment Multiplier", SCLSet.DynEquipModifier, "x{2}")
    AddSliderOptionST("DynMinSize_S", "$Dynamic Equipment Minimum Value", SCLSet.DynMinSize, "{1}")
    AddEmptyOption()

    ;/If SCLSet.InflateMethodArray[SCLSet.BellyInflateMethod] == "Equipment"
      AddSliderOptionST("EquipmentTierSelect_S", "Select Tier", SelectedEquipmentTier, "Tier {0}") ;17
      AddSliderOptionST("EquipmentTierEdit_S", "Select Threshold", SCLSet.BEquipmentLevels[SelectedEquipmentTier], "Threshold = {0}")
      AddTextOptionST("ResetEquipmentTiers_T", "Reset All Thresholds", "")
      AddEmptyOption()
    EndIf/;
    AddEmptyOption()
    AddEmptyOption()
    AddHeaderOption("Waste Function Settings")
    AddKeyMapOptionST("WF_ActionKeyPick_KM", "$Choose Waste Function Action Key", SCLSet.WF_ActionKey)
    AddSliderOptionST("SetAVDestination_S", "$Choose Anal Vore Behavior.", SCVSet.AVDestinationChoice, "Option {0}")
    AddToggleOptionST("WF_Enable_TOG", "$Enable Waste Needs Functions", SCLSet.WF_NeedsActive)
    AddHeaderOption("Other Settings")
    AddHeaderOption("")
    AddSliderOptionST("PlayerMessagePOV_S", "$Message POV", SCLSet.PlayerMessagePOV, SCLib.addIntSuffix(SCLSet.PlayerMessagePOV))
    AddKeyMapOptionST("ActionKeyPick_KM", "$Choose Action key", SCLSet.ActionKey)
    If SCVSet.SizeMatters_Initialized
      AddToggleOptionST("SizeMattersActive_TOG", "Enable Size Matters Functions", SCVSet.SizeMattersActive)
      AddEmptyOption()
    EndIf
    AddToggleOptionST("GodMode1_TOG", "$Enable God Mode", SCLSet.GodMode1)
    AddToggleOptionST("DebugEnable_TOG", "$Debug Mode", SCLSet.DebugEnable)
    If SCLSet.DebugEnable
      AddToggleOptionST("ShowDebugMessages_TOG", "Display Debug Messages", SCLSet.ShowDebugMessages)
      If SCLSet.ShowDebugMessages
        AddToggleOptionST("ShowDebugMessages01_TOG", "Show Message 01", SCLib.getDMEnable(1))
        AddToggleOptionST("ShowDebugMessages02_TOG", "Show Message 02", SCLib.getDMEnable(2))
        AddToggleOptionST("ShowDebugMessages03_TOG", "Show Message 03", SCLib.getDMEnable(3))
        AddToggleOptionST("ShowDebugMessages04_TOG", "Show Message 04", SCLib.getDMEnable(4))
        AddToggleOptionST("ShowDebugMessages05_TOG", "Show Message 05", SCLib.getDMEnable(5))
        AddToggleOptionST("ShowDebugMessages06_TOG", "Show Message 06", SCLib.getDMEnable(6))
        AddToggleOptionST("ShowDebugMessages07_TOG", "Show Message 07", SCLib.getDMEnable(7))
        AddToggleOptionST("ShowDebugMessages08_TOG", "Show Message 08", SCLib.getDMEnable(8))
        AddToggleOptionST("ShowDebugMessages09_TOG", "Show Message 09", SCLib.getDMEnable(9))
      EndIf
    EndIf
  EndIf
EndEvent

State DisplayIsOVPred_T
  Event OnSelectST()
    If SCLSet.DebugEnable
      SCVLib.togOVPred(SelectedActor, SelectedData)
      SCVLib.checkPredAbilities(SelectedActor, SelectedData)
      SetTextOptionValueST(SCVLib.isOVPred(SelectedActor, SelectedData))
    EndIf
  EndEvent

  Event OnDefaultST()
    If SCLSet.DebugEnable
      SCVLib.setOVPred(SelectedActor, False, SelectedData)
      SetTextOptionValueST(False)
    EndIf
  EndEvent

  Event OnHighlightST()
    If SCLSet.DebugEnable
      SetInfoText("Click here to toggle oral predator status for this actor")
    Else
      SetInfoText("Is this actor an oral predator")
    EndIf
  EndEvent
EndState

State DisplayIsAVPred_T
  Event OnSelectST()
    If SCLSet.DebugEnable
      SCVLib.togAVPred(SelectedActor, SelectedData)
      SCVLib.checkPredAbilities(SelectedActor, SelectedData)
      SetTextOptionValueST(SCVLib.isAVPred(SelectedActor, SelectedData))
    EndIf
  EndEvent

  Event OnDefaultST()
    If SCLSet.DebugEnable
      SCVLib.setAVPred(SelectedActor, False, SelectedData)
      SetTextOptionValueST(False)
    EndIf
  EndEvent

  Event OnHighlightST()
    If SCLSet.DebugEnable
      SetInfoText("Click here to toggle anal predator status for this actor")
    Else
      SetInfoText("Is this actor an anal predator")
    EndIf
  EndEvent
EndState

State EditOVLevel_S
  Event OnSliderOpenST()
    Int OV = SCVLib.getOVLevel(SelectedActor, SelectedData)
    SetSliderDialogStartValue(OV)
    SetSliderDialogDefaultValue(OV)
    SetSliderDialogRange(1, 100)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVLib.setOVLevel(SelectedActor, a_value as Int, SelectedData)
    SCVLib.setOVExp(SelectedActor, 0, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCVLib.setOVLevel(SelectedActor, 1, SelectedData)
    SCVLib.setOVExp(SelectedActor, 0, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set the actor's learned oral vore level (will reset vore exp.)")
  EndEvent
EndState

State EditAVLevel_S
  Event OnSliderOpenST()
    Int AV = SCVLib.getAVLevel(SelectedActor, SelectedData)
    SetSliderDialogStartValue(AV)
    SetSliderDialogDefaultValue(AV)
    SetSliderDialogRange(1, 100)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVLib.setAVLevel(SelectedActor, a_value as Int, SelectedData)
    SCVLib.setAVExp(SelectedActor, 0, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCVLib.setAVLevel(SelectedActor, 1, SelectedData)
    SCVLib.setAVExp(SelectedActor, 0, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set the actor's learned anal vore level (will reset vore exp.)")
  EndEvent
EndState

State DisplayOVLevel_T
  Event OnHighlightST()
    SetInfoText("Actor's learned oral vore level.")
  EndEvent
EndState

State DisplayAVLevel_T
  Event OnHighlightST()
    SetInfoText("Actor's learned anal vore level.")
  EndEvent
EndState

State DisplayOVExp_T
  Event OnHighlightST()
    SetInfoText("Actor's oral vore EXP.")
  EndEvent
EndState

State DisplayAVExp_T
  Event OnHighlightST()
    SetInfoText("Actor's anal vore EXP.")
  EndEvent
EndState

State EditOVLevelExtra_S
  Event OnSliderOpenST()
    Int OV = SCVLib.getOVLevelExtra(SelectedActor, SelectedData)
    SetSliderDialogStartValue(OV)
    SetSliderDialogDefaultValue(OV)
    SetSliderDialogRange(1, 300)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVLib.setOVLevelExtra(SelectedActor, a_value as Int, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCVLib.setOVLevelExtra(SelectedActor, 1, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set the actor's extra oral vore level")
  EndEvent
EndState

State EditAVLevelExtra_S
  Event OnSliderOpenST()
    Int AV = SCVLib.getAVLevelExtra(SelectedActor, SelectedData)
    SetSliderDialogStartValue(AV)
    SetSliderDialogDefaultValue(AV)
    SetSliderDialogRange(1, 300)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVLib.setAVLevelExtra(SelectedActor, a_value as Int, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCVLib.setAVLevelExtra(SelectedActor, 1, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set the actor's extra anal vore level")
  EndEvent
EndState

State DisplayOVLevelExtra_T
  Event OnHighlightST()
    SetInfoText("Actor's extra oral vore level.")
  EndEvent
EndState

State DisplayAVLevelExtra_T
  Event OnHighlightST()
    SetInfoText("Actor's extra anal vore level.")
  EndEvent
EndState

State EditResistLevel_S
  Event OnSliderOpenST()
    Int Res = SCVLib.getResLevel(SelectedActor, SelectedData)
    SetSliderDialogStartValue(Res)
    SetSliderDialogDefaultValue(Res)
    SetSliderDialogRange(1, 100)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVLib.setResLevel(SelectedActor, a_value as Int, SelectedData)
    SCVLib.setResExp(SelectedActor, 0, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCVLib.setResLevel(SelectedActor, 1, SelectedData)
    SCVLib.setResExp(SelectedActor, 0, SelectedData)
    ForcePageReset()
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set the actor's learned resist level (will reset resist exp).")
  EndEvent
EndState

State DisplayResistLevel_T
  Event OnHighlightST()
    SetInfoText("Actor's learned resist level.")
  EndEvent
EndState

State DisplayResistExp_T
  Event OnHighlightST()
    SetInfoText("Actor's resist EXP")
  EndEvent
EndState

State DisplayCurrentDigestValue
  Event OnHighlightST()
    SetInfoText("How much the actor weighs. Based on how much food they've eaten, how much they have in their inventory, race, size, etc. Affects how difficult they are to eat.")
  EndEvent
EndState

State DisplayNumAvoidVore
  Event OnHighlightST()
    SetInfoText("Number of times the actor has avoided being eaten.")
  EndEvent
EndState

State DisplayStrokesOfLuck
  Event OnHighlightST()
    SetInfoText("Number of times the actor has been unusually lucky against preds.")
  EndEvent
EndState

State UnknownDisplay
  Event OnHighlightST()
    SetInfoText("?????")
  EndEvent
EndState

State DisplayNumDragonGems
  Event OnHighlightST()
    SetInfoText("Number of dragon gems consumed.")
  EndEvent
EndState

State EssentialPreyList_M
  Event OnMenuOpenST()
    EssentialPreyList = SCVSet.SCVEssential.getActorList()
    Int NumActors = EssentialPreyList.length
    String[] ActorNames = Utility.CreateStringArray(NumActors, "")
    Int i = 0
    While i < NumActors
      Actor EssActor = EssentialPreyList[i] as Actor
      If EssActor
        ActorNames[i] = SCVLib.nameGet(EssActor)
      EndIf
      i += 1
    EndWhile
    SetMenuDialogOptions(ActorNames)
    SetMenuDialogStartIndex(0)
    SetMenuDialogDefaultIndex(0)
  EndEvent

  Event OnMenuAcceptST(int a_index)
    If ShowMessage("Restore " + SCVLib.nameGet(EssentialPreyList[a_index] as Actor) + "?")
      SCVSet.SCVEssential.restoreActor(EssentialPreyList[a_index] as Actor)
    EndIf
  EndEvent

  Event OnHighlightST()
    SetInfoText("List of essential actors that have been lethally devoured. Select one to restore them.")
  EndEvent
EndState
;Settings **********************************************************************
State EnableMPreds_TOG
  Event OnSelectST()
    SCVSet.EnableMPreds = !SCVSet.EnableMPreds
    SetToggleOptionValueST(SCVSet.EnableMPreds)
  EndEvent

  Event OnDefaultST()
    SCVSet.EnableMPreds = False
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Enable Male NPC Predators.")
  EndEvent
EndState

State EnableFPreds_TOG
  Event OnSelectST()
    SCVSet.EnableFPreds = !SCVSet.EnableFPreds
    SetToggleOptionValueST(SCVSet.EnableFPreds)
  EndEvent

  Event OnDefaultST()
    SCVSet.EnableFPreds = False
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Enable Female NPC Predators.")
  EndEvent
EndState

State EnableMTeamPreds_TOG
  Event OnSelectST()
    SCVSet.EnableMTeamPreds = !SCVSet.EnableMTeamPreds
    SetToggleOptionValueST(SCVSet.EnableMTeamPreds)
  EndEvent

  Event OnDefaultST()
    SCVSet.EnableMTeamPreds = False
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Enable Male Teammate Predators.")
  EndEvent
EndState

State EnableFTeamPreds_TOG
  Event OnSelectST()
    SCVSet.EnableFTeamPreds = !SCVSet.EnableFTeamPreds
    SetToggleOptionValueST(SCVSet.EnableFTeamPreds)
  EndEvent

  Event OnDefaultST()
    SCVSet.EnableFTeamPreds = False
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Enable Female Teammate Predators.")
  EndEvent
EndState

State EnableEssential_TOG
  Event OnSelectST()
    SCVSet.EnableEssentialVore = !SCVSet.EnableEssentialVore
    SetToggleOptionValueST(SCVSet.EnableEssentialVore)
  EndEvent

  Event OnDefaultST()
    SCVSet.EnableEssentialVore = False
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Enable devouring of essential NPCs by other NPCs.")
  EndEvent
EndState

State EnablePlayerEssential_TOG
  Event OnSelectST()
    SCVSet.EnablePlayerEssentialVore = !SCVSet.EnablePlayerEssentialVore
    SetToggleOptionValueST(SCVSet.EnablePlayerEssentialVore)
  EndEvent

  Event OnDefaultST()
    SCVSet.EnablePlayerEssentialVore = False
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Enable devouring of essential NPCs by the player.")
  EndEvent
EndState

State OVPredPercent_S
  Event OnSliderOpenST()
    SetSliderDialogStartValue(SCVSet.OVPredPercent)
    SetSliderDialogDefaultValue(SCVSet.OVPredPercent)
    SetSliderDialogRange(0, 100)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVSet.OVPredPercent = a_value as Int
    SetSliderOptionValueST(a_value, "{0} Percent")
  EndEvent

  Event OnDefaultST()
    SCVSet.OVPredPercent = 30
    SetSliderOptionValueST(30, "{0} Percent")
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set percentage of oral predators")
  EndEvent
EndState

State AVPredPercent_S
  Event OnSliderOpenST()
    SetSliderDialogStartValue(SCVSet.AVPredPercent)
    SetSliderDialogDefaultValue(SCVSet.AVPredPercent)
    SetSliderDialogRange(0, 100)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVSet.AVPredPercent = a_value as Int
    SetSliderOptionValueST(a_value, "{0} Percent")
  EndEvent

  Event OnDefaultST()
    SCVSet.AVPredPercent = 30
    SetSliderOptionValueST(30, "{0} Percent")
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set percentage of anal predators")
  EndEvent
EndState

State SetAVDestination_S
  Event OnSliderOpenST()
    SetSliderDialogStartValue(SCVSet.AVDestinationChoice)
    SetSliderDialogDefaultValue(SCVSet.AVDestinationChoice)
    SetSliderDialogRange(0, 1)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVSet.AVDestinationChoice = a_value as Int
    SetSliderOptionValueST(a_value, "Option {0}")
  EndEvent

  Event OnDefaultST()
    SCVSet.AVDestinationChoice = 0
    SetSliderOptionValueST(0, "Option {0}")
  EndEvent

  Event OnHighlightST()
    SetInfoText("Sets how anal vore behaves (0 = Sent to Colon containers, 1 = Sent to Stomach containers)")
  EndEvent
EndState

State StruggleMod_S
  Event OnSliderOpenST()
    SetSliderDialogStartValue(SCVSet.StruggleMod)
    SetSliderDialogDefaultValue(SCVSet.StruggleMod)
    SetSliderDialogRange(0, 20)
    SetSliderDialogInterval(0.5)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVSet.StruggleMod = a_value
    SetSliderOptionValueST(a_value, "x{1}")
  EndEvent

  Event OnDefaultST()
    SCVSet.StruggleMod = 7
    SetSliderOptionValueST(7, "x{1}")
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set struggle modifier (Increases stamina/magicka damage per update).")
  EndEvent
EndState

State DamageMod_S
  Event OnSliderOpenST()
    SetSliderDialogStartValue(SCVSet.DamageMod)
    SetSliderDialogDefaultValue(SCVSet.DamageMod)
    SetSliderDialogRange(0, 20)
    SetSliderDialogInterval(0.5)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVSet.DamageMod = a_value
    SetSliderOptionValueST(a_value, "x{1}")
  EndEvent

  Event OnDefaultST()
    SCVSet.DamageMod = 3
    SetSliderOptionValueST(3, "x{1}")
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set damage modifier (Increases health damage per update).")
  EndEvent
EndState

State DebugEnable_TOG
	Event OnSelectST()
		SCLSet.DebugEnable = !SCLSet.DebugEnable
    SCVLib.checkDebugSpells()
    ForcePageReset()
	EndEvent

	Event OnDefaultST()
    SCLSet.DebugEnable = False
    SCVLib.checkDebugSpells()
    ForcePageReset()
	EndEvent
EndState

State ShowDebugMessages07_TOG
  Event OnSelectST()
    SCLib.togDMEnable(7)
    SetToggleOptionValueST(SCLib.getDMEnable(7))
  EndEvent

  Event OnDefaultST()
    SCLib.setDMEnable(7, False)
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Show debug notifications ID 07")
  EndEvent
EndState

State ShowDebugMessages08_TOG
  Event OnSelectST()
    SCLib.togDMEnable(8)
    SetToggleOptionValueST(SCLib.getDMEnable(8))
  EndEvent

  Event OnDefaultST()
    SCLib.setDMEnable(8, False)
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Show debug notifications ID 08")
  EndEvent
EndState

State ShowDebugMessages09_TOG
  Event OnSelectST()
    SCLib.togDMEnable(9)
    SetToggleOptionValueST(SCLib.getDMEnable(9))
  EndEvent

  Event OnDefaultST()
    SCLib.setDMEnable(9, False)
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Show debug notifications ID 09")
  EndEvent
EndState

State SizeMattersActive_TOG
  Event OnSelectST()
    SCVSet.SizeMattersActive = !SCVSet.SizeMattersActive
    SetToggleOptionValueST(SCVSet.SizeMattersActive)
  EndEvent

  Event OnDefaultST()
    SCVSet.SizeMattersActive = False
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Actors gain size from nourishment from prey after digestion (Requires Size Matters).")
  EndEvent
EndState
