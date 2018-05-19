ScriptName SCVModConfig Extends SKI_ConfigBase
String DebugName = "[SCVMCM ]"
Int DMID = 8
Int ScriptVersion = 1
Function CheckSCVVersion()
  Int StoredVersion = JDB.solveInt(".SCLExtraData.VersionRecords.SCVMenu")
  Bool HasUpdated = False
  ;/If ScriptVersion >= 1 && StoredVersion < 3
    MCMInitialized = False
    Debug.Notification("Beginning update to version 1")
    ;Do stuff here
  EndIf/;
  JDB.solveIntSetter(".SCLExtraData.VersionRecords.SCVMenu", ScriptVersion, True)

  MCMInitialized = True
  If HasUpdated
    Debug.Notification("SCV Updated! Please check your settings.")
  EndIf
EndFunction

SCVLibrary Property SCVLib Auto
SCVDatabase Property SCVData Auto
SCLModConfig Property SCLMCM Auto
SCLSettings Property SCLSet Auto
SCVSettings Property SCVSet Auto

Actor Property PlayerRef Auto

Bool Property MCMInitialized Auto

Bool SCLResetted

;Events ************************************************************************
Event OnConfigInit()
  checkBaseDependencies()
  RegisterForModEvent("SCLMCMStart", "OnMenuStart")
EndEvent

Event OnGameReload()
  Parent.OnGameReload()
  If SCLResetted
    ;Stuff here
  EndIf

  If MCMInitialized
    CheckSCVVersion()
    CheckBaseDependencies()
    SCVData.setupInstalledMods()
  EndIf
EndEvent

Event OnConfigClose()
  SCVLib.checkDebugSpells()
EndEvent

Event OnMenuStart()
  Pages = new String[2]
  Pages[0] = "Actor Information"
  Pages[1] = "Settings"
  MCMInitialized = True
EndEvent

Event OnPageReset(string a_page)
  If !MCMInitialized
    AddTextOptionST("StartSCLWarning_T", "Please Start SCL", "")
  ElseIf a_page == "Actor Information"
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddMenuOptionST("SelectedActor_M", "Actor", SCLMCM.SelectedActorName);0
    If SCLMCM.SelectedActor
      Int AD = SCLMCM.SelectedData
      Actor S = SCLMCM.SelectedActor
      AddTextOptionST("DisplayIsOVPred_T", "Is a Predator?", SCVLib.isOVPred(S, AD)) ;4
      AddEmptyOption()
      If SCLSet.DebugEnable
        AddSliderOptionST("EditOVLevel_S", "Oral Vore Level", SCVLib.getOVLevel(S, AD), "{0}")  ;8
        AddSliderOptionST("EditOVLevelExtra_S", "Extra Oral Vore Level", SCVLib.getOVLevelExtra(S, AD), "{0}")  ;10
      Else
        AddTextOptionST("DisplayOVLevel_T", "Oral Vore Level", SCVLib.getOVLevel(S, AD))
        AddTextOptionST("DisplayOVLevelExtra_T", "Extra Oral Vore Level", SCVLib.getOVLevelExtra(S, AD))
      EndIf
      AddTextOptionST("DisplayOVExp_T", "Oral Vore Exp", SCVLib.getOVEXP(S, AD) + "/" + SCVLib.getOVEXPThreshold(SCVLib.getOVLevel(S,AD)))  ;12

      AddMenuOptionST("DisplayStomachContents_M", "Show Stomach Contents", "")  ;20
      If SCLSet.DebugEnable
        AddSliderOptionST("EditBase_S", "Base Capacity", JMap.getFlt(AD, "STBase"), "{1} Units")
      Else
        AddTextOptionST("DisplayBase_T", "Current Base Capacity", JMap.getFlt(AD, "STBase"))
      EndIf

      If SCLSet.DebugEnable
        AddSliderOptionST("EditResistLevel_S", "Resistance Level", SCVlib.getResLevel(S, AD), "{0}") ;9
      Else
        AddTextOptionST("DisplayResistLevel_T", "Resistance Level", SCVlib.getResLevel(S, AD))
      EndIf

      AddTextOptionST("DisplayResistExp_T", "Resistance Exp", SCVLib.getResEXP(S, AD) + "/" + SCVLib.getResEXPThreshold(SCVLib.getResLevel(S, AD))) ;11
    Else
      AddTextOptionST("ChooseActorMessage_T", "Choose an actor.", "")
    EndIf
  ElseIf(a_page == "Actor Perks")
    AddMenuOptionST("SelectedActor_M", "Actor", SCLMCM.SelectedActorName);0
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddEmptyOption()
    If SCLMCM.SelectedActor
      Int AD = SCLMCM.SelectedData
      Actor S = SCLMCM.SelectedActor
      AddHeaderOption("Predator Perks") ;4
      addPerkOption(S, "SCV_IntenseHunger")
      addPerkOption(S, "SCV_MetalMuncher")
      addPerkOption(S, "SCV_FollowerofNamira")
      addPerkOption(S, "SCV_DragonDevourer")
      addPerkOption(S, "SCV_SpiritSwallower")
      addPerkOption(S, "SCV_ExpiredEpicurian")
      addPerkOption(S, "SCV_DaedraDieter")
      addPerkOption(S, "SCV_Stalker")
      addPerkOption(S, "SCV_RemoveLimits")
      addPerkOption(S, "SCV_Constriction")
      addPerkOption(S, "SCV_Nourish")
      addPerkOption(S, "SCV_Acid")

      SetCursorPosition(5)
      AddHeaderOption("Resistance Perks") ;5
      addPerkOption(S, "SCV_StrokeOfLuck")
      addPerkOption(S, "SCV_ExpectPushback")
      addPerkOption(S, "SCV_CorneredRat")
      addPerkOption(S, "SCV_FillingMeal")
      addPerkOption(S, "SCV_ThrillingStruggle")
    Else
      AddTextOptionST("ChooseActorMessage_T", "Choose an actor.", "")
    Endif
  ElseIf a_page == "Settings"
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddToggleOptionST("EnableMPreds_TOG", "Enable Male NPC Predators", SCVSet.EnableMPreds)
    AddToggleOptionST("EnableFPreds_TOG", "Enable Female NPC Predators", SCVSet.EnableFPreds)

    AddToggleOptionST("EnableMTeamPreds_TOG", "Enable Male Teammate Predators", SCVSet.EnableMTeamPreds)
    AddToggleOptionST("EnableFTeamPreds_TOG", "Enable Female Teammate Predators", SCVSet.EnableFTeamPreds)

    AddToggleOptionST("EnablePlayerEssential_TOG", "Enable Player Devouring Essential NPCs", SCVSet.EnablePlayerEssentialVore)
    AddToggleOptionST("EnableEssential_TOG", "Enable Devouring Essential NPCs", SCVSet.EnableEssentialVore)

    AddSliderOptionST("OVPredPercent_S", "Oral Predator Percentage", SCVSet.OVPredPercent, "{0} Percent")

    AddToggleOptionST("ActionKeyEnable_TOG", "Enable SCV Action Key", SCVSet.ActionKeyEnable)
    If SCVSet.ActionKeyEnable
      AddKeyMapOptionST("ActionKeyPick_KM", "Choose Action key", SCVSet.ActionKey)
    Else
      SCVSet.ActionKey = 0
      AddEmptyOption()
    EndIf

    AddToggleOptionST("DebugEnable_TOG", "Debug Mode", SCLSet.DebugEnable)
    If SCLSet.DebugEnable
      AddToggleOptionST("ShowDebugMessages_TOG", "Display Debug Messages", SCVLib.getDMEnable(8))
    EndIf
  EndIf
EndEvent

State StartSCLWarning_T
  Event OnHighlightST()
    SetInfoText("Please start Skyrim Capacity Limited before continuing")
  EndEvent
EndState

State SelectedActor_M
  Event OnMenuOpenST()
    If !SCLSet.LoadedActors
      SCLSet.LoadedActors = SCVLib.getLoadedActors()
    EndIf
    Int NumActors = SCLSet.LoadedActors.length
    Int StartIndex = 0
    String[] ActorNames = Utility.CreateStringArray(NumActors, "")
    Int i = 0
    While i < NumActors
      Actor LoadedActor = SCLSet.LoadedActors[i] as Actor
      If LoadedActor == SCLMCM.SelectedActor
        StartIndex = i
      EndIf
      ActorNames[i] = SCVLib.nameGet(LoadedActor)
      i += 1
    EndWhile
    SetMenuDialogOptions(ActorNames)
    SetMenuDialogStartIndex(StartIndex)
    SetMenuDialogDefaultIndex(0)
  EndEvent

  Event OnMenuAcceptST(int a_index)
    SCLMCM.SelectedActor = SCLSet.LoadedActors[a_index] as Actor
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCLMCM.SelectedActor = PlayerRef
    ForcePageReset()
  EndEvent

  Event OnHighlightST()
    SetInfoText("Which actor?")
  EndEvent
EndState

State DisplayIsOVPred_T
  Event OnSelectST()
    If SCLSet.DebugEnable
      SCVLib.togOVPred(SCLMCM.SelectedActor, SCLMCM.SelectedData)
      SCVLib.checkPredAbilities(SCLMCM.SelectedActor, SCLMCM.SelectedData)
      SetTextOptionValueST(SCVLib.isOVPred(SCLMCM.SelectedActor, SCLMCM.SelectedData))
    EndIf
  EndEvent

  Event OnDefaultST()
    If SCLSet.DebugEnable
      SCVLib.setOVPred(SCLMCM.SelectedActor, False, SCLMCM.SelectedData)
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

State EditOVLevel_S
  Event OnSliderOpenST()
    Int OV = SCVLib.getOVLevel(SCLMCM.SelectedActor, SCLMCM.SelectedData)
    SetSliderDialogStartValue(OV)
    SetSliderDialogDefaultValue(OV)
    SetSliderDialogRange(1, 100)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVLib.setOVLevel(SCLMCM.SelectedActor, a_value as Int, SCLMCM.SelectedData)
    SCVLib.setOVExp(SCLMCM.SelectedActor, 0, SCLMCM.SelectedData)
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCVLib.setOVLevel(SCLMCM.SelectedActor, 1, SCLMCM.SelectedData)
    SCVLib.setOVExp(SCLMCM.SelectedActor, 0, SCLMCM.SelectedData)
    ForcePageReset()
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set the actor's learned oral vore level (will reset vore exp.)")
  EndEvent
EndState

State DisplayOVLevel_T
  Event OnHighlightST()
    SetInfoText("Actor's learned oral vore level.")
  EndEvent
EndState

State DisplayOVExp_T
  Event OnHighlightST()
    SetInfoText("Actor's oral vore EXP.")
  EndEvent
EndState

State EditOVLevelExtra_S
  Event OnSliderOpenST()
    Int OV = SCVLib.getOVLevelExtra(SCLMCM.SelectedActor, SCLMCM.SelectedData)
    SetSliderDialogStartValue(OV)
    SetSliderDialogDefaultValue(OV)
    SetSliderDialogRange(1, 300)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVLib.setOVLevelExtra(SCLMCM.SelectedActor, a_value as Int, SCLMCM.SelectedData)
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCVLib.setOVLevelExtra(SCLMCM.SelectedActor, 1, SCLMCM.SelectedData)
    ForcePageReset()
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set the actor's extra oral vore level")
  EndEvent
EndState

State DisplayOVLevelExtra_T
  Event OnHighlightST()
    SetInfoText("Actor's extra oral vore level.")
  EndEvent
EndState

State DisplayStomachContents_M
	Event OnMenuOpenST()
    Int JF_CompleteContents = SCVLib.getCompleteContents(SCLMCM.SelectedActor, SCLMCM.SelectedData)
    Int NumEntries = JFormMap.count(JF_CompleteContents)
    String[] FoodEntries = Utility.CreateStringArray(NumEntries, "")
    Int i = 0
    While i < NumEntries
      Form ItemKey = JFormMap.getNthKey(JF_CompleteContents, i)
      Int JM_ItemEntry = JFormMap.getObj(JF_CompleteContents, ItemKey)
      Int ItemType = JMap.getInt(JM_ItemEntry, "ItemType")
      String ItemName = SCVLib.nameGet(ItemKey)
      String ShortDesc = SCVLib.getShortItemTypeDesc(ItemType)
      String DValue = SCVLib.roundFlt(JMap.getFlt(JM_ItemEntry, "DigestValue"), 2)
      String ItemEntry
      If ItemKey as SCLBundle
        ItemEntry = ItemName + "x" + (ItemKey as SCLBundle).NumItems + ": " + ShortDesc + ", " + DValue
      Else
        ItemEntry = ItemName + ": " + ShortDesc + ", " + DValue
      EndIf
      FoodEntries[i] = ItemEntry
      i += 1
    EndWhile
    SetMenuDialogStartIndex(0)
    SetMenuDialogDefaultIndex(0)
    SetMenuDialogOptions(FoodEntries)
  EndEvent

	Event OnHighlightST()
		SetInfoText("Display contents of stomach")
	EndEvent
EndState

State EditBase_S
	Event OnSliderOpenST()
		SetSliderDialogStartValue(JMap.getFlt(SCLMCM.SelectedData, "STBase"))
		SetSliderDialogDefaultValue(JMap.getFlt(SCLMCM.SelectedData, "STBase"))
		SetSliderDialogRange(1, 2000)
		SetSliderDialogInterval(1)
	EndEvent

	Event OnSliderAcceptST(Float a_value)
		JMap.setFlt(SCLMCM.SelectedData, "STBase", a_value)
		SetSliderOptionValueST(a_value, "{0}")
    ForcePageReset()
	EndEvent

	Event OnDefaultST()
			JMap.setFlt(SCLMCM.SelectedData, "STBase", 3)
			SetSliderOptionValueST(3, "{0}")
      ForcePageReset()
	EndEvent

	Event OnHighlightST()
		SetInfoText("Set the actor's base stomach capacity")
	EndEvent
EndState

State DisplayBase_T
  Event OnHighlightST()
    SetInfoText("Actor's base stomach capacity")
  EndEvent
EndState

State EditResistLevel_S
  Event OnSliderOpenST()
    Int Res = SCVLib.getResLevel(SCLMCM.SelectedActor, SCLMCM.SelectedData)
    SetSliderDialogStartValue(Res)
    SetSliderDialogDefaultValue(Res)
    SetSliderDialogRange(1, 100)
    SetSliderDialogInterval(1)
  EndEvent

  Event OnSliderAcceptST(float a_value)
    SCVLib.setResLevel(SCLMCM.SelectedActor, a_value as Int, SCLMCM.SelectedData)
    SCVLib.setResExp(SCLMCM.SelectedActor, 0, SCLMCM.SelectedData)
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCVLib.setResLevel(SCLMCM.SelectedActor, 1, SCLMCM.SelectedData)
    SCVLib.setResExp(SCLMCM.SelectedActor, 0, SCLMCM.SelectedData)
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

State ChooseActorMessage_T
  Event OnHighlightST()
    setInfoText("Please choose an actor.")
  EndEvent
EndState

;Perks *************************************************************************
State SCV_IntenseHunger_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_IntenseHunger")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_IntenseHunger")
  EndEvent
EndState

State SCV_MetalMuncher_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_MetalMuncher")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_MetalMuncher")
  EndEvent
EndState

State SCV_FollowerofNamira_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_FollowerofNamira")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_FollowerofNamira")
  EndEvent
EndState

State SCV_DragonDevourer_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_DragonDevourer")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_DragonDevourer")
  EndEvent
EndState

State SCV_SpiritSwallower_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_SpiritSwallower")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_SpiritSwallower")
  EndEvent
EndState

State SCV_ExpiredEpicurian_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_ExpiredEpicurian")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_ExpiredEpicurian")
  EndEvent
EndState

State SCV_DaedraDieter_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_DaedraDieter")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_DaedraDieter")
  EndEvent
EndState

State SCV_Stalker_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_Stalker")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_Stalker")
  EndEvent
EndState

State SCV_RemoveLimits_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_RemoveLimits")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_RemoveLimits")
  EndEvent
EndState

State SCV_Constriction_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_Constriction")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_Constriction")
  EndEvent
EndState

State SCV_Nourish_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_Nourish")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_Nourish")
  EndEvent
EndState

State SCV_Acid_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_Acid")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_Acid")
  EndEvent
EndState

State SCV_StrokeOfLuck_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_StrokeOfLuck")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_StrokeOfLuck")
  EndEvent
EndState

State SCV_ExpectPushback_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_ExpectPushback")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_ExpectPushback")
  EndEvent
EndState

State SCV_CorneredRat_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_CorneredRat")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_CorneredRat")
  EndEvent
EndState

State SCV_FillingMeal_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_FillingMeal")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_FillingMeal")
  EndEvent
EndState

State SCV_ThrillingStruggle_T
  Event OnSelectST()
    setPerkOption(SCLMCM.SelectedActor, "SCV_ThrillingStruggle")
  EndEvent

  Event OnHighlightST()
    setPerkInfo(SCLMCM.SelectedActor, "SCV_ThrillingStruggle")
  EndEvent
EndState

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

State ActionKeyEnable_TOG
  Event OnSelectST()
    SCVSet.ActionKeyEnable = !SCVSet.ActionKeyEnable
    ForcePageReset()
  EndEvent

  Event OnDefaultST()
    SCVSet.ActionKeyEnable = False
    ForcePageReset()
  EndEvent

  Event OnHighlightST()
    SetInfoText("Allows performing SCV actions directly by pressing the Action Key")
  EndEvent
EndState

State ActionKeyPick_KM
	Event OnKeyMapChangeST(int a_keyCode, string a_conflictControl, string a_conflictName)
		Bool Continue = True
		If a_conflictControl != ""
			String msg
			If a_conflictName != ""
				msg = a_conflictControl + ": This key is already registered to " + a_conflictName + ". Are sure you want to continue?"
			Else
				msg = a_conflictControl + ": This key is already registered. Are you sure you want to continue?"
			EndIf
			Continue = ShowMessage(msg, true, "Yes", "No")
		EndIf
		If Continue
			SCVSet.ActionKey = a_keyCode
			SetKeyMapOptionValueST(a_keyCode)
		EndIf
	EndEvent

  Event OnDefaultST()
    SCVSet.ActionKey = 0
    SetKeyMapOptionValueST(0)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Set key for interacting with things")
  EndEvent
EndState

State DebugEnable_TOG
	Event OnSelectST()
		SCLSet.DebugEnable = !SCLSet.DebugEnable
    ForcePageReset()
	EndEvent

	Event OnDefaultST()
    SCLSet.DebugEnable = False
    ForcePageReset()
	EndEvent

	Event OnHighlightST()
		SetInfoText("Allow debug functions in MCM. Also allows editing actor stats.")
	EndEvent
EndState

State ShowDebugMessages_TOG
  Event OnSelectST()
    SCVLib.togDMEnable(8)
    SetToggleOptionValueST(SCVLib.getDMEnable(8))
  EndEvent

  Event OnDefaultST()
    SCVLib.setDMEnable(8, False)
    SetToggleOptionValueST(False)
  EndEvent

  Event OnHighlightST()
    SetInfoText("Show debug notifications for SCV ID 8")
  EndEvent
EndState
;*******************************************************************************
;Functions
;*******************************************************************************
Bool Function addPerkOption(Actor akTarget, String asPerkID)
  Int CurrentPerkValue = SCVLib.getCurrentPerkLevel(akTarget, asPerkID)
  Bool CanTake = SCVLib.canTakePerk(akTarget, asPerkID, SCLSet.DebugEnable)
  If CurrentPerkValue || CanTake
    If CanTake
      AddTextOptionST(asPerkID + "_T", SCVLib.getPerkName(asPerkID, CurrentPerkValue + 1), "Take")
    Else
      AddTextOptionST(asPerkID + "_T", SCVLib.getPerkName(asPerkID, CurrentPerkValue), "Taken")
    EndIf
    Return True
  Else
    Return False
  EndIf
EndFunction

Function setPerkOption(Actor akTarget, String asPerkID)
  If SCVLib.canTakePerk(akTarget, asPerkID, SCLSet.DebugEnable)
    SCVLib.takePerk(akTarget, asPerkID)
    ShowMessage("Perk " + SCVLib.getPerkName(asPerkID, SCVLib.getCurrentPerkLevel(akTarget, asPerkID)) + " taken! Some perk effects will not show until the menu is exited", False, "OK")
    ForcePageReset()
  Else
    ShowMessage(SCVLib.getPerkDescription(asPerkID, SCVLib.getCurrentPerkLevel(akTarget, asPerkID)), False, "OK")
  EndIf
EndFunction

Function setPerkInfo(Actor akTarget, String asPerkID)
  Int CurrentPerkValue = SCVLib.getCurrentPerkLevel(akTarget, asPerkID)
  SetInfoText(SCVLib.getPerkDescription(asPerkID, CurrentPerkValue))
EndFunction

String Function GetCustomControl(int keyCode)
	If (keyCode == SCVSet.ActionKey)
		Return " SCV Action Key"
	Else
		Return ""
	EndIf
EndFunction

Function checkBaseDependencies()
  Notice("Checking base dependencies...")
  If !SCLibrary.isModInstalled("SCL.esp")
    Popup("Skyrim Capacity Limited not installed! Please exit game and install.")
  EndIf
EndFunction

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

Bool Function PlayerThoughtDB(Actor akTarget, String sKey, Int iOverride = 0)
  {Use this to display player information. Returns whether the passed actor is
  the player.
  Pulls message from database; make sure sKey is valid.
  Will add POV int to end of key, so omit it in the parameter}
  If akTarget == PlayerRef
    Int Setting
    If iOverride != 0
      Setting = iOverride
    Else
      Setting = SCLSet.PlayerMessagePOV
    EndIf
    String sMessage = SCVLib.getMessage(sKey + Setting)
    If sMessage
      Debug.Notification(sMessage)
    Else
      PlayerThought(akTarget, SCVLib.getMessage(sKey + 1), SCVLib.getMessage(sKey + 2), SCVLib.getMessage(sKey + 3))
    EndIf
    Return True
  Else
    Return False
  EndIf
EndFunction

Function Popup(String sMessage)
  {Shows MessageBox, then waits for menu to be closed before continuing}
  Debug.MessageBox(DebugName + sMessage)
  Halt()
EndFunction

Function Halt()
  {Wait for menu to be closed before continuing}
  While Utility.IsInMenuMode()
    Utility.Wait(0.5)
  EndWhile
EndFunction

Function Note(String sMessage)
  Debug.Notification(DebugName + sMessage)
EndFunction

Function Notice(String sMessage, Int aiID = 0)
  {Displays message in notifications and logs if globals are active}
  If SCLSet.ShowDebugMessages && SCVLib.getDMEnable(DMID)
    Debug.Notification(DebugName + sMessage)
  EndIf
  Debug.Trace(DebugName + sMessage)
EndFunction

Function Issue(String sMessage, Int iSeverity = 0, Bool bOverride = False)
  {Displays a serious message in notifications and logs if globals are active
  Use bOverride to ignore globals}
  If bOverride || (SCLSet.ShowDebugMessages && SCVLib.getDMEnable(DMID))
    String Level
    If iSeverity == 0
      Level = "Info"
    ElseIf iSeverity == 1
      Level = "Warning"
    ElseIf iSeverity == 2
      Level = "Error"
    EndIf
    Debug.Notification(DebugName + Level + " " + sMessage)
  EndIf
  Debug.Trace(DebugName + sMessage, iSeverity)
EndFunction
