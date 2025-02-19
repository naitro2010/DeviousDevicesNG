Scriptname zadLibs extends Quest

{ 
DDI framework conventions:
The vision of Devious Devices is providing a foundation for a mulitude of bondage-themed mods users can install and enjoy at the same time. Due to the unique characteristics of a large family of mods providing content having a strong potential to affect each other, the following conventions for the use of the DD framework API are in effect, to ensure maximum compatibility and fair play between DD mods. DD content mods are expected to respect these conventions. Linking to the DD framework and use of the DD API is considered consent to these conventions. The DD team reserves the right to take necessary steps to ensure the integrity of these framework conventions.

1. DD content mods shall not overwrite standard framework features with their own. Other mods will rely on framework resources working the way they are coded/defined in the framework. If you want to create custom devices or behavior, clone the items or features in question and change them locally, in your own mod. In particular, do not make ANY changes to the base scripts.
2. Do not re-pack/re-distribute any framework resources with your own mod. All framework assets are subject to changes and having outdated framework resources packed in DD content mods is just creating a support nightmare for everyone involved. You CAN re-use code or portions thereof, but give the scripts new names, in your own namespace.
3. The zad_ and zadx_ namespaces are reserved for the framework. Please use your own namespace for your custom assets to avoid confusion and accidental incompatibilities.
4. Standard keys and standard items can be created/dropped/crafted/sold by any content mod at their own discretion. DD mods should not rely on standard keys to be difficult to obtain etc.
5. Items not marked with either zad_BlockGeneric OR zad_QuestItem are considered generic and can be removed by any DD mod at any time for any reason, including helpful blacksmiths, mercyful NPCs etc.
6. Items marked with zad_BlockGeneric should NOT be removed by third party mods via trivial means of escape (e.g. blacksmith dialogues) or without compelling reason. They can be removed -when necessary-, to be replaced with quest items (and these only!), or temporarily, if required to run a scene etc. In the latter case, the removing mod is expected to equip back the item after completing the scene.
7. Items tagged with zad_QuestItem mark essential items that are not to be removed for ANY reason by any content mod other than the mod that equipped them and the framework itself. Modders are asked to use this tag sparingly and only when warranted, as this might prevent other mods' quests or scenes from getting started. Live and let live!
8. DD content mods are strongly encouraged to provide a local means to terminate their quests and remove their items upon user request, -particularly- if they make use of zad_QuestItem tagged items. The framework will send the DDI_Quest_SigTerm mod event if the user triggers the built-in DDI debug function. It is encouraged to register for this event and terminate/clean up all local DD quests when it's received.
}

; Libraries
SexLabFramework property SexLab auto
; import sslExpressionLibrary
import StringUtil
import zadNativeFunctions
import zadprebuildedexpressions

slaUtilScr Property Aroused Auto
zadConfig Property Config Auto
zadNPCQuestScript Property zadNPCQuest Auto
zadArmbinderQuestScript Property abq Auto
zadYokeQuestScript Property ybq Auto
zadEventSlots Property EventSlots Auto ; See zadBaseEvent.psc for how to use the new events system.
zadDevicesUnderneathScript Property DevicesUnderneath Auto
Quest Property zadNPCSlots Auto
zadBoundCombatScript Property BoundCombat auto
Int Property TweenMenuKey Auto
bool Property Terminate Auto
zadexpressionlibs Property ExpLibs auto ;expression libs
vrikActions Property _vrikActions = None Auto
  
; Keywords
Keyword Property zad_DeviousPlug Auto
Keyword Property zad_DeviousBelt Auto
Keyword Property zad_DeviousBra Auto
Keyword Property zad_DeviousCollar Auto
Keyword Property zad_DeviousArmCuffs Auto
Keyword Property zad_DeviousLegCuffs Auto
Keyword Property zad_DeviousArmbinder Auto
Keyword Property zad_DeviousArmbinderElbow Auto
Keyword Property zad_DeviousHeavyBondage Auto
Keyword Property zad_DeviousHobbleSkirt Auto
Keyword Property zad_DeviousHobbleSkirtRelaxed Auto
Keyword Property zad_DeviousAnkleShackles Auto
Keyword Property zad_DeviousStraitJacket Auto
Keyword Property zad_DeviousCuffsFront Auto
Keyword Property zad_DeviousPetSuit Auto
Keyword Property zad_DeviousYoke Auto
Keyword Property zad_DeviousYokeBB Auto
Keyword Property zad_DeviousCorset Auto
Keyword Property zad_DeviousClamps Auto
Keyword Property zad_DeviousGloves Auto
Keyword Property zad_DeviousHood Auto
Keyword Property zad_DeviousSuit Auto
Keyword Property zad_DeviousElbowTie Auto
Keyword Property zad_DeviousGag Auto
Keyword Property zad_DeviousGagLarge Auto
Keyword Property zad_DeviousGagPanel Auto
Keyword Property zad_DeviousPlugVaginal Auto
Keyword Property zad_DeviousPlugAnal Auto
Keyword Property zad_DeviousHarness Auto
Keyword Property zad_DeviousBlindfold Auto
Keyword Property zad_DeviousBoots Auto
Keyword Property zad_Lockable Auto
Keyword Property zad_DeviousPiercingsNipple Auto
Keyword Property zad_DeviousPiercingsVaginal Auto
Keyword Property zad_DeviousBondageMittens Auto
Keyword Property zad_DeviousPonyGear Auto
Keyword Property zad_PermitOral Auto
Keyword Property zad_PermitAnal Auto
Keyword Property zad_PermitVaginal Auto

Keyword Property zad_InventoryDevice Auto
Keyword Property zad_BlockGeneric Auto ; Block generic removal of this device.
Keyword Property zad_QuestItem Auto ; Quest item tag. This item can not be removed conventionally.

Keyword Property zad_BraNoBlockPiercings Auto
Keyword Property zad_GagNoOpenMouth Auto
Keyword Property zad_GagCustomExpression Auto

Keyword Property zad_BoundCombatDisableKick Auto

Keyword Property zad_NonUniqueKey Auto		; A key tagged with this keyword will be consumed by the global Destroy Key feature, if enabled by the user.

Keyword Property zad_BlockGenericEvents Auto
Keyword Property zad_ExposedBreasts Auto

; All standard devices, at this time. Shorthand for mods, and to avoid the hassle of re-adding these as properties for other scripts.
; If you're using a custom device, you'll need to use EquipDevice, rather than the shorthand ManipulateDevice.
Armor Property beltPaddedRendered Auto         ; Internal Device
Armor Property beltPadded Auto        	       ; Inventory Device
Armor Property beltIronRendered Auto         ; Internal Device
Armor Property beltIron Auto        	     ; Inventory Device
Armor Property plugIronRendered Auto         ; Internal Device
Armor Property plugIron Auto        	     ; Inventory Device
Armor Property plugPrimitiveRendered Auto         ; Internal Device
Armor Property plugPrimitive Auto        	  ; Inventory Device
Armor Property plugInflatableRendered Auto         ; Internal Device
Armor Property plugInflatable Auto        	   ; Inventory Device
Armor Property plugSoulgemRendered Auto         ; Internal Device
Armor Property plugSoulgem Auto        		; Inventory Device
Armor Property braPaddedRendered Auto         ; Internal Device
Armor Property braPadded Auto        	      ; Inventory Device
Armor Property cuffsPaddedArmsRendered Auto         ; Internal Device
Armor Property cuffsPaddedArms Auto        	    ; Inventory Device
Armor Property cuffsPaddedLegsRendered Auto         ; Internal Device
Armor Property cuffsPaddedLegs Auto        	    ; Inventory Device
Armor Property cuffsPaddedCollarRendered Auto         ; Internal Device
Armor Property cuffsPaddedCollar Auto        	      ; Inventory Device
Armor Property cuffsPaddedCompleteRendered Auto         ; Internal Device
Armor Property cuffsPaddedComplete Auto        		; Inventory Device
Armor Property collarPostureRendered Auto         ; Internal Device
Armor Property collarPosture Auto        	  ; Inventory Device
Armor Property armbinderRendered Auto         ; Internal Device
Armor Property armbinder Auto        	  ; Inventory Device
Armor Property zad_armBinderHisec_Rendered Auto
Armor Property zad_armBinderHisec_Inventory Auto
Armor Property gagBall Auto
Armor Property gagBallRendered Auto
Armor Property gagPanel Auto
Armor Property gagPanelRendered Auto
Armor Property gagRing Auto
Armor Property gagRingRendered Auto

Armor Property gagStrapBall Auto                   ; Inventory Device
Armor Property gagStrapBallRendered Auto           ; Internal Device
Armor Property gagStrapRing Auto                   ; Inventory Device
Armor Property gagStrapRingRendered Auto           ; Internal Device
Armor Property blindfold Auto                        ; Inventory Device
Armor Property blindfoldRendered Auto                ; Internal Device
Armor Property cuffsLeatherArms Auto                 ; Inventory Device
Armor Property cuffsLeatherArmsRendered Auto         ; Internal Device
Armor Property cuffsLeatherLegs Auto                 ; Inventory Device
Armor Property cuffsLeatherLegsRendered Auto         ; Internal Device
Armor Property cuffsLeatherCollar Auto               ; Inventory Device
Armor Property cuffsLeatherCollarRendered Auto       ; Internal Device
Armor Property harnessBody Auto                          ; Inventory Device
Armor Property harnessBodyRendered Auto                  ; Internal Device
Armor Property harnessCollar Auto                  ; Inventory Device
Armor Property harnessCollarRendered Auto          ; Internal Device
Armor Property collarPostureLeather Auto
Armor Property collarPostureLeatherRendered Auto

Armor Property plugIronVag Auto                  ; Internal Device
Armor Property plugIronVagRendered Auto          ; Internal Device
Armor Property plugIronAn Auto                  ; Internal Device
Armor Property plugIronAnRendered Auto          ; Internal Device
Armor Property plugPrimitiveVag Auto                  ; Internal Device
Armor Property plugPrimitiveVagRendered Auto          ; Internal Device
Armor Property plugPrimitiveAn Auto                  ; Internal Device
Armor Property plugPrimitiveAnRendered Auto          ; Internal Device
Armor Property plugSoulgemVag Auto                  ; Internal Device
Armor Property plugSoulgemVagRendered Auto          ; Internal Device
Armor Property plugSoulgemAn Auto                  ; Internal Device
Armor Property plugSoulgemAnRendered Auto          ; Internal Device
Armor Property plugInflatableVag Auto                  ; Internal Device
Armor Property plugInflatableVagRendered Auto          ; Internal Device
Armor Property plugInflatableAn Auto                  ; Internal Device
Armor Property plugInflatableAnRendered Auto          ; Internal Device
Armor Property beltPaddedOpen Auto        	       ; Inventory Device
Armor Property beltPaddedOpenRendered Auto         ; Internal Device
Armor Property plugChargeableVag Auto
Armor Property plugChargeableRenderedVag Auto
Armor Property plugTrainingVag Auto
Armor Property plugTrainingRenderedVag Auto

Armor Property collarRestrictive Auto
Armor Property collarRestrictiveRendered Auto
Armor Property corset Auto
Armor Property corsetRendered Auto
Armor Property glovesRestrictive Auto
Armor Property glovesRestrictiveRendered Auto
Armor Property yoke Auto
Armor Property yokeRendered Auto

Armor Property piercingVSoul Auto
Armor Property piercingVSoulRendered Auto
Armor Property piercingNSoul Auto
Armor Property piercingNSoulRendered Auto

; Keys
Key Property chastityKey Auto
Key Property restraintsKey Auto
Key Property piercingKey Auto ; Piercing removal tool

; Sound fx
Sound Property VibrateVeryStrongSound Auto
Sound Property VibrateStrongSound Auto
Sound Property VibrateStandardSound Auto
Sound Property VibrateWeakSound Auto
Sound Property VibrateVeryWeakSound Auto
Sound Property EdgedSound Auto
Sound Property OrgasmSound  Auto
Sound Property MoanSound Auto
Sound Property GaggedSound Auto
Sound Property ShortMoanSound Auto
Sound Property ShortPantSound Auto

; Idles
Idle Property DD_FT_Unconcious Auto
Idle Property DD_FT_Surrender Auto
Idle Property DD_FT_Surrender_Hobbled Auto
Idle Property DD_FT_Bleedout_Armbinder Auto
Idle Property DD_FT_Bleedout_BBYoke Auto
Idle Property DD_FT_Bleedout_Elbowbinder Auto
Idle Property DD_FT_Bleedout_Frontcuffs Auto
Idle Property DD_FT_Bleedout_Yoke Auto
Idle Property DD_FT_CollarMe Auto
Idle Property DD_FT_Egyptian Auto
Idle Property DD_FT_Inspection Auto

Package Property zad_pk_surrender Auto
Package Property zad_pk_surrender_hobbled Auto
Package Property zad_pk_collarme Auto
Package Property zad_pk_egyptian Auto
Package Property zad_pk_inspection Auto

; Dialogue disable
GlobalVariable Property DialogueGagDisable Auto
GlobalVariable Property DialogueArmbinderDisable Auto

; Factions
Faction Property zadAnimatingFaction Auto
Faction Property zadVibratorFaction Auto
Faction Property zadGagPanelFaction Auto
Faction Property zadDisableDialogueFaction Auto

MiscObject Property zad_gagPanelPlug Auto
Outfit Property zadEmptyOutfit Auto

;Default Message for the new escape system to use as a fallback in case a legacy device doesn't have one defined.
Message Property zad_DeviceEscapeMsg Auto	; Device escape message
GlobalVariable Property zadDeviceEscapeSuccessCount Auto ; counter for succesful escape attempts
MiscObject Property Lockpick Auto
FormList Property zad_DD_StandardCuttingToolsList Auto		; List of allowed cutting tools
Message Property zad_DD_EscapeDeviceMSG Auto 				; Device escape dialogue. You can customize it if you want, but make sure not to change the order and functionality of the buttons.
Message Property zad_DD_OnEquipDeviceMSG Auto 				; Message is displayed upon device equip (dialogue only)
Message Property zad_DD_OnNoKeyMSG Auto 	 				; Message is displayed when the player has no key
Message Property zad_DD_OnNotEnoughKeysMSG	Auto 			; Message is displayed when the player has not enough keys
Message Property zad_DD_OnLeaveItNotWornMSG Auto 	 		; Message is displayed when the player clicks the "Leave it Alone" button while not wearing the device.
Message Property zad_DD_OnLeaveItWornMSG Auto 		 		; Message is displayed when the player clicks the "Leave it Alone" button while wearing the device.
Message Property zad_DD_KeyBreakMSG Auto 	 				; Message is displayed when a key breaks while trying to unlock this device.
Message Property zad_DD_KeyBreakJamMSG Auto 				; Message is displayed when a key breaks and gets stuck in the lock when trying to unlock this device.
Message Property zad_DD_UnlockFailJammedMSG	Auto 			; Message displayed when a player tries to unlock a jammed device.
Message Property zad_DD_RepairLockNotJammedMSG Auto 		; Message displayed when a player tries to repair a device that's not jammed.
Message Property zad_DD_RepairLockMSG Auto 					; Message displayed when a player tries to repair a lock.
Message Property zad_DD_RepairLockSuccessMSG Auto 			; Message displayed when a player successfully tries to repair a lock.
Message Property zad_DD_RepairLockFailureMSG Auto 			; Message displayed when a player fails to repair a lock.
Message Property zad_DD_EscapeStruggleMSG Auto 				; Message to be displayed when the player tries to struggle out of a restraint
Message Property zad_DD_EscapeStruggleFailureMSG Auto 		; Message to be displayed when the player fails to struggle out of a restraint
Message Property zad_DD_EscapeStruggleSuccessMSG Auto 		; Message to be displayed when the player succeeds to struggle out of a restraint
Message Property zad_DD_EscapeLockPickMSG Auto 				; Message to be displayed when the player tries to pick a restraint
Message Property zad_DD_EscapeLockPickFailureMSG Auto 		; Message to be displayed when the player fails to pick a restraint
Message Property zad_DD_EscapeLockPickSuccessMSG Auto 		; Message to be displayed when the player succeeds to pick a restraint
Message Property zad_DD_EscapeCutMSG Auto 					; Message to be displayed when the player tries to cut a restraint
Message Property zad_DD_EscapeCutFailureMSG Auto 			; Message to be displayed when the player fails to cut a restraint
Message Property zad_DD_EscapeCutSuccessMSG Auto 			; Message to be displayed when the player succeeds to cut open a restraint
Message Property zad_DD_OnPutOnDevice Auto					; Message to be displayed when the player locks on an item, so she can manipulate the locks if she choses.

; Internal Variables
Armor Property deviceRemovalToken Auto         ; Internal token for removal events
Bool Property DeviceMutex Auto ; Prevent oddities when swapping sets of items quickly.
Bool Property GlobalEventFlag Auto ; Events enabled/disabled, globally. Useful for scenes that don't want to be interrupted.
bool Property RepopulateMutex Auto ; Avoid 2.6.3 bug
Float Property lastRepopulateTime Auto ; Avoid 2.6.3 bug
bool Property EnableVRSupport = False Auto
  
; Misc
Actor Property PlayerRef Auto
Faction Property SexLabAnimatingFaction Auto
Spell Property ShockEffect Auto
Float Property SpellCastVibrateCooldown Auto
Spell Property zad_splMagickaPenalty Auto
bool Property BoundAnimsAvailable = True Auto ; Obsolete. Bound anims are now always available, post zap 6
FormList Property zadStandardKeywords Auto
Keyword Property questItemRemovalAuthorizationToken = None Auto
FormList Property zadDeviceTypes Auto	; List of all main device type keywords. Useful for iterating functions.
FormList Property zad_AlwaysSilent Auto	; Actors in this list will ALWAYS equip or unequip DD items silently.


; Rechargeable Soulgem Stuff
Soulgem Property SoulgemEmpty Auto
Soulgem Property SoulgemFilled Auto
MiscObject Property SoulgemStand Auto
Perk Property LustgemCrafting Auto

; Inflatable Plugs
Keyword Property zad_kw_InflatablePlugAnal Auto
Keyword Property zad_kw_InflatablePlugVaginal Auto
GlobalVariable Property zadInflatablePlugStateAnal Auto
GlobalVariable Property zadInflatablePlugStateVaginal Auto
Float Property LastInflationAdjustmentVaginal = 0.0 Auto
Float Property LastInflationAdjustmentAnal = 0.0 Auto
Message Property zad_PlugsConfirmMSG Auto
Message Property zad_PlugsDeflatePumpsFail Auto

; Nipple Piercings
Perk Property PiercedNipples Auto
Perk Property PiercedClit Auto

Spell Property PiercedNipplesSpell Auto
Spell Property PiercedClitSpell Auto

;;;;Effects
Keyword Property zad_HasPumps Auto

; stuff for NPC interaction

Keyword Property ActorTypeNPC Auto
Keyword Property ActorTypeAnimal Auto
Keyword Property ActorTypeCreature Auto
Race Property ManakinRace Auto
Faction Property currentfollowerfaction Auto
Keyword Property ActorTypeDwarven Auto
Faction Property dunPrisonerFaction Auto
Faction Property isGuardFaction Auto
Race Property ElderRace Auto
Keyword Property isBeastRace Auto

; Keywords for Device Effects
Keyword Property zad_EffectVibratingVeryStrong Auto
Keyword Property zad_EffectVibratingStrong Auto
Keyword Property zad_EffectVibrating Auto
Keyword Property zad_EffectVibratingWeak Auto
Keyword Property zad_EffectVibratingVeryWeak Auto
Keyword Property zad_EffectVibratingRandom Auto
Keyword Property zad_EffectVibrateOnSpellCast Auto
Keyword Property zad_EffectTrainOnSpellCast Auto
Keyword Property zad_EffectElectroStim Auto

Keyword Property zad_EffectHealthDraining Auto
Keyword Property zad_EffectStaminaDraining Auto
Keyword Property zad_EffectManaDraining Auto

Keyword Property zad_EffectShocking Auto ; Periodically shock actor.
Keyword Property zad_EffectChaosPlug Auto ; Coopervane's Random Plug.
Keyword Property zad_EffectShockOnFullArousal Auto ; Instead of vibrating, shock on full arousal.

 ; Effect modifiers
Keyword Property zad_EffectPossessed Auto ; Plugs will function stand-alone if this keyword is present.
Keyword Property zad_EffectRemote Auto

Keyword Property zad_EffectLively Auto       ; Increase chance of effect beyond mcm config.
Keyword Property zad_EffectVeryLively Auto   ; Further increase chance of effect. Stacks.

Keyword Property zad_EffectEdgeOnly Auto    ; Will never let the player cum for stimulating events (Vibration)
Keyword Property zad_EffectEdgeRandom Auto    ; Will sometimes let the player cum for stimulating events (Vibration)

Keyword Property zad_EffectsLinked Auto      ; If one effect fires, all effects fire.
Keyword Property zad_EffectCompressBreasts Auto ; Compress breasts to avoid hdt clipping through bras.
Keyword Property zad_NoCompressBreasts Auto ; Disable Compressing of breasts, despite previous keyword
Keyword Property zad_EffectCompressBelly Auto ; Compress belly to avoid hdt clipping through corsets, belts and harnesses.
Keyword Property zad_NoCompressBelly Auto ; Disable Compressing of belly, despite previous keyword
Keyword Property zad_EffectForcedWalk Auto ; Responsible for muting encumberance messages on reload, related to the zadx_ForcedWalk magiceffect


;===============================================================================
; Public Interface Functions
;===============================================================================
; There are two items for each type of item in this system: An inventory item, and a rendered item.
; The inventory item is the user-facing item that the user may interact with. The rendered item is
; the item that actually shows up on characters. The reason for this two item system is twofold:
; Firstly, this permits us to allow the user to interact with the item freely, without seeing the
; item unequip every time / without resorting to spells/powers. Secondly, the rendered item acts
;  as an surrogate-state of sorts that is useful for internal scripts.
; Each category of item managed by this system must have a unique keyword. This keyword must be 
; present on the rendered device. For instance, all belts provided by devious devices contain the
; keyword zad_DeviousBelt. If you add custom belts, you must use either my existing keywords, or
; add your own keyword for a different type of device.


; Use this function to lock a device on an actor. It's way, waaaaay, WAY faster than the old EquipDevice() and doesn't even 
; need the rendered device or keyword, because the OnEquipped() event will process all the needed operations, which has direct access to these properties.
; The force parameter will make the function try to equip the given item, even if another (generic) item is already worn.
Bool Function LockDevice(actor akActor, armor deviceInventory, bool force = false)
	Log("LockDevice called for " + akActor.GetLeveledActorBase().GetName() + ": "+ deviceInventory.GetName() + ")")
	If force
		Keyword kw = GetDeviceKeyword(deviceInventory)
		if kw
			return SwapDevices(akActor, deviceInventory, zad_DeviousDevice = kw)						
		EndIf
	EndIf	
	if akActor.GetItemCount(deviceInventory) <= 0
		akActor.AddItem(deviceInventory, 1, true)
	EndIf		
	akActor.EquipItemEx(deviceInventory, 0, false, true)	
	return true
EndFunction

; Remove device from actor. For NPCs, fires the events etc, just like UnEquipped() would.
; Passing the rendered device and/or keyword is 100% unneeded for the player, but it will make the routine perform a LOT faster if at least the keyword is given for NPCs.
; If at least the keyword is given, this is STILL lightning-fast, otherwise the device will get determined the slow way. Meh!
; On the plus side, ALL pre-5.0 mods had to provide the keyword and the rendered device anyway, so existing stuff will still enjoy a nice speed-boost.
; The parameter genericonly is set to false by default to mirror the behavior of the old RemoveDevice() function (which will for the time being still be in API and route calls to this function).
; If this function is used in place of the old ManipulateGenericDevice() function, make sure to pass genericonly = true
; Mind you that this function assumes the block_generic and quest_item flags to be present on the inventory device, not (just) the rendered device. Most mods seemed to do that already,
; but unexpected behavior might occur if the keywords are on the rendered device only.
Bool Function UnlockDevice(actor akActor, armor deviceInventory, armor deviceRendered = none, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = false)
	Log("UnlockDevice called for " + akActor.GetLeveledActorBase().GetName() + ": "+ deviceInventory.GetName() + ")")
	If (genericonly && deviceInventory.HasKeyWord(zad_BlockGeneric)) || deviceInventory.HasKeyWord(zad_QuestItem)
		Log("UnlockDevice aborted because " + deviceInventory.GetName() + " is not a generic item.")
		return false
	Endif				
	if akActor.IsEquipped(deviceInventory) 
		StorageUtil.SetIntValue(akActor, "zad_RemovalToken" + deviceInventory, 1)		
		akActor.UnequipItemEx(deviceInventory, 0, false)
	else
		; NPCs often don't have their worn gear actually marked as equipped, so the above code would fail super-duper hard and do exactly..nothing.
		; Same when more than one copy of a device worn is in the inventory, even for the player. 
		; Well, the later has been considered a "known issue" for as long as DD existed, so there is that... :S
		; Stupid Skyrim derp engine! Even force-equipping a device before calling UnEquipItem() fails 20-30% of the time, so we have to do this the hard way.		
		Armor rDevice
		Keyword kw		
		if !zad_DeviousDevice
			kw = GetDeviceKeyword(deviceInventory)
			; this is a slow operation - For NPC's, TRY to provide the function with the keyword if you at all can!
		else
			kw = zad_DeviousDevice
		EndIf
		if !deviceRendered
			rdevice = GetWornRenderedDeviceByKeyword(akActor, kw)			
		else
			rdevice = deviceRendered
		EndIf		
		akActor.RemoveItem(rdevice, 1, true)
		; duplicate all the crap that normally would be handled by OnUnequipped() or OnRemoveDevice(), because it won't be called in this case. Gah!!!!!!!!
		 If (kw == zad_DeviousHeavyBondage || kw == zad_DeviousPonyGear || kw == zad_DeviousHobbleSkirt)
			log("Removing Bound Effects")
			BoundCombat.EvaluateAA(akActor)
		EndIf		
		If kw == zad_DeviousGag
			log("Removing Gag Effects")
			RemoveGagEffect(akActor)
			if rDevice.HasKeyWord(zad_DeviousGagPanel)
				if akActor.GetFactionRank(zadGagPanelFaction) == 0
					akActor.RemoveItem(zad_GagPanelPlug, 1)
				EndIf
				akActor.SetFactionRank(zadGagPanelFaction, 0)
				akActor.RemoveFromFaction(zadGagPanelFaction)
			EndIf
		EndIf
		UnsetStoredDevice(akActor, kw)		
		SendDeviceRemovalEvent(LookupDeviceType(zad_DeviousDevice), akActor)
		SendDeviceRemovedEventVerbose(deviceInventory, kw, akActor)		
		Log("UnlockDevice: " + akActor.GetLeveledActorBase().GetName() + "'s " + deviceInventory.GetName() + " has been removed.")
	EndIf    
	if destroyDevice
		akActor.RemoveItem(deviceInventory, 1, true)
    EndIf	
	return true
EndFunction

; Use this function to safely replace a worn item with the given one. If genericonly is set to false, the function will also replace devices marked with zad_BlockGeneric.
; It is not necessary to pass the device keyword, but the function will perform much faster if you do.
; This function will behave like LockDevice() if no conflicting device is equipped, but it WILL be slower, if no keyword is provided.
Bool Function SwapDevices(actor akActor, armor deviceInventory, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = true)
	Log("SwapDevices called for " + akActor.GetLeveledActorBase().GetName() + ": "+ deviceInventory.GetName() + ")")
	Keyword kw		
	if !zad_DeviousDevice
		kw = GetDeviceKeyword(deviceInventory)		
	else
		kw = zad_DeviousDevice
	EndIf	
	Armor WornDevice = GetWornRenderedDeviceByKeyword(akActor, kw)
	if WornDevice
		Armor idevice = GetWornDevice(akActor, kw)		
		if !UnlockDevice(akActor, idevice, WornDevice, zad_DeviousDevice = kw, destroyDevice = destroyDevice, genericonly = genericonly)
			log("UnlockDevice() failed. Aborting.")
			return false
		EndIf		
		int counter = 5 
		while akActor.IsEquipped(WornDevice) && counter > 0
			log("Removing " + idevice.GetName() + ". Waiting for removal operation to complete.")			
			counter -= 1
			Utility.Wait(1)
		EndWhile
		if akActor.IsEquipped(WornDevice) && counter == 0
			log("Unlock operation timed out and failed. Aborting.")
			return false
		EndIf
		Utility.Wait(1)
		log("Device removed. Proceeding.")
	Else
		log("No confilicting device worn. Proceeding.")
	EndIf	
	if akActor.GetItemCount(deviceInventory) <= 0
		akActor.AddItem(deviceInventory, 1, true)
	EndIf		
	akActor.EquipItemEx(deviceInventory, 0, false, true)	
	return true
EndFunction

; Removes a device in a given slot by providing a keyword.
Bool Function UnlockDeviceByKeyword(actor akActor, keyword zad_DeviousDevice, bool destroyDevice = false)
	Log("UnlockDeviceByKeyword called for " + zad_DeviousDevice)					
	Armor idevice = GetWornDevice(akActor, zad_DeviousDevice)
	if UnlockDevice(akActor, idevice, zad_DeviousDevice = zad_DeviousDevice, destroyDevice = destroyDevice, genericonly = true)
		return true
	EndIf
	return false
EndFunction

; Remove quest device from actor. To make sure the removal is legit this will work only if the keyword passed to the function in the RemovalToken parameter is present on the item. Standard DD and ZAP keywords will not be accepted. 
; As of 5.0, the skipMutex parameter is ignored, as DDI does not support mutexes anymore.
Function RemoveQuestDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, keyword RemovalToken, bool destroyDevice=false, bool skipMutex=false)
	Log("RemoveQuestDevice called for " + deviceInventory.GetName())
	if !akActor.IsEquipped(deviceInventory) && !akActor.IsEquipped(deviceRendered)
		Warn("RemoveQuestDevice called for " + deviceInventory +", but this device is not currently worn.")
		return
	EndIf	
	If !deviceInventory.HasKeyword(zad_QuestItem) &&  !deviceRendered.HasKeyword(zad_QuestItem)
		Log("RemoveQuestDevice aborted for " + deviceInventory.GetName() + " because it's not a quest item.")
		return
	EndIf
	If !RemovalToken || zadStandardKeywords.HasForm(RemovalToken) || !(deviceInventory.HasKeyword(RemovalToken) || deviceRendered.HasKeyword(RemovalToken))
		Log("RemoveQuestDevice called for " + deviceInventory.GetName() + " with invalid removal token. Aborted.")
		return
	EndIf		
	questItemRemovalAuthorizationToken = RemovalToken
	StorageUtil.SetIntValue(akActor, "zad_RemovalToken" + deviceInventory, 1)
	akActor.UnequipItemEx(deviceInventory, 0, false)
	akActor.RemoveItem(deviceRendered, 1, true) 		
    if destroyDevice
		akActor.RemoveItem(deviceInventory, 1, true)
    EndIf	
EndFunction

; Returns 0 if the actor is not wearing a device of this type, 1 if she is wearing
; that specific device, or 2 if she's wearing another device of the same type.
int Function IsWearingDevice(actor akActor, armor deviceRendered, keyword zad_DeviousDevice)
	if akActor == none || deviceRendered == none || zad_DeviousDevice == none
		Error("IsWearingDevice received none argument.")
		return -1
	EndIf
	if akActor.WornHasKeyword(zad_DeviousDevice)
		if akActor.GetItemCount(deviceRendered)==0
			return 2
		Endif
		return 1
	EndIf
	return 0
EndFunction

; Tighten a device (replace the worn device with the one defined in the property), if one is linked in the device property. Will do nothing, if there isn't one set.
; Warning: if the linked device cannot be equipped due to slot conflicts, the function will fail without feedback.
; Works only for player
Bool Function TightenDevice(actor akActor, armor deviceInventory)
	If deviceInventory.HasKeyWord(zad_QuestItem)
		Log("TightenDevice aborted because " + deviceInventory.GetName() + " is a quest item.")
		return false
	Endif			
	if akActor == PlayerRef && akActor.IsEquipped(deviceInventory) 
		StorageUtil.SetIntValue(akActor, "zad_RemovalToken" + deviceInventory, 1)
		StorageUtil.SetIntValue(akActor, "zad_TightenToken" + deviceInventory, 1)
		akActor.UnequipItemEx(deviceInventory, 0, false)	
		return true
	EndIf
	return false
EndFunction

; Untighten a device (replace the worn device with the one defined in the property). If none is linked, the device will be just unlocked.
; Warning: if the linked device cannot be equipped due to slot conflicts, the function will fail without feedback.
; Works only for player
Bool Function UntightenDevice(actor akActor, armor deviceInventory)
	If deviceInventory.HasKeyWord(zad_QuestItem)
		Log("UntightenDevice aborted because " + deviceInventory.GetName() + " is a quest item.")
		return false
	Endif
	if akActor == PlayerRef && akActor.IsEquipped(deviceInventory) 
		StorageUtil.SetIntValue(akActor, "zad_RemovalToken" + deviceInventory, 1)
		StorageUtil.SetIntValue(akActor, "zad_UntightenToken" + deviceInventory, 1)
		akActor.UnequipItemEx(deviceInventory, 0, false)	
		return true
	EndIf
	return false
EndFunction

; checks if a given inventory device can be tightened
Bool Function CanTightenDevice(actor akActor, armor akDeviceInventory)
    return zadNativeFunctions.GetPropertyForm(akDeviceInventory,"LinkedDeviceEquipOnTighten")
EndFunction

; checks if a given inventory device can be untightened
Bool Function CanUntightenDevice(actor akActor, Armor akDeviceInventory)
    return zadNativeFunctions.GetPropertyForm(akDeviceInventory,"LinkedDeviceEquipOnUntighten")
EndFunction

; checks if the lock for a given device slot is jammed, works only on the player for now. Will return 1 if the lock is jammed, 0 if it isn't and -1 if an error occured.
Int Function IsLockJammed(actor akActor, keyword zad_DeviousDevice)
	If akActor != playerRef || !akActor.WornHasKeyword(zad_DeviousDevice)
		return -1
	Endif
	If StorageUtil.GetIntValue(akActor, "zad_Equipped" + LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus") == 1
		return 1
	Endif
	return 0
EndFunction

; I am sure this function will be cruel fun for some modders *cough*
Bool Function JamLock(actor akActor, keyword zad_DeviousDevice)
	If akActor != playerRef || !akActor.WornHasKeyword(zad_DeviousDevice)
		return False
	Endif
	StorageUtil.SetIntValue(akActor, "zad_Equipped" + LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus", 1)
	return True
EndFunction

Bool Function UnJamLock(actor akActor, keyword zad_DeviousDevice)
	If akActor != playerRef || !akActor.WornHasKeyword(zad_DeviousDevice)
		return False
	Endif
	StorageUtil.SetIntValue(akActor, "zad_Equipped" + LookupDeviceType(zad_DeviousDevice) + "_LockJammedStatus", 0)
	return True
EndFunction

; No, I really can't memorize all these DD slots....
Int Function GetSlotMaskForDeviceType(Keyword kw)
	if kw == zad_DeviousArmCuffs
		return Armor.GetMaskForSlot(59)
	elseif kw == zad_DeviousGag
		return Armor.GetMaskForSlot(44)
	elseif kw == zad_DeviousHarness
		return Armor.GetMaskForSlot(58)
	elseif kw == zad_DeviousCorset
		return Armor.GetMaskForSlot(58)
	elseif kw == zad_DeviousCollar
		return Armor.GetMaskForSlot(45)
	elseif kw == zad_DeviousHeavyBondage
		If PlayerRef.WornHasKeyword(zad_DeviousStraitJacket)
            return Armor.GetMaskForSlot(32)
        Else    
            return Armor.GetMaskForSlot(46)
        EndIf  
	elseif kw == zad_DeviousPlugAnal
		return Armor.GetMaskForSlot(48)
	elseif kw == zad_DeviousBelt
		return Armor.GetMaskForSlot(49)
	elseif kw == zad_DeviousPiercingsVaginal
		return Armor.GetMaskForSlot(50)
	elseif kw == zad_DeviousPiercingsNipple
		return Armor.GetMaskForSlot(51)
	elseif kw == zad_DeviousLegCuffs
		return Armor.GetMaskForSlot(53)
	elseif kw == zad_DeviousBlindfold
		return Armor.GetMaskForSlot(55)
	elseif kw == zad_DeviousBra
		return Armor.GetMaskForSlot(56)
	elseif kw == zad_DeviousPlugVaginal
		return Armor.GetMaskForSlot(57)
	elseif kw == zad_DeviousSuit
		return Armor.GetMaskForSlot(32)
	elseif kw == zad_DeviousGloves
		return Armor.GetMaskForSlot(33)	
	elseif kw == zad_DeviousHood
		return Armor.GetMaskForSlot(30)	
	elseif kw == zad_DeviousBoots
		return Armor.GetMaskForSlot(37)	
	EndIf
	return -1
EndFunction

; This is a waaaaay faster version of getting the script instance of a given slot. Works only for actually equipped items of course!
Armor Function GetWornRenderedDeviceByKeyword(Actor a, Keyword kw)
	Int i = GetSlotMaskForDeviceType(kw)
	if i == -1
		return None
	EndIf
	Armor x = a.GetWornForm(i) As Armor 
	if x && x.HasKeyWord(zad_Lockable)
		return x
	EndIf
	return none
EndFunction

; determines if a device in a given slot is generic (e.g. no quest device). Caution: Works for equipped devices only.
Bool Function IsGenericDevice(Actor a, Keyword kw)
	Armor arm = GetWornRenderedDeviceByKeyword(a, kw)	
	if arm && arm.HasKeyword(zad_BlockGeneric) || arm.HasKeyword(zad_QuestItem)
		return false
	EndIf
	return true
EndFunction

; returns if a given device has a manipulated lock
Bool Function IsLockManipulated(Actor a, Keyword kw)
	if a != PlayerRef || !a.WornHasKeyword(kw)
		return false
	EndIf
	If StorageUtil.GetIntValue(a, "zad_Equipped" + LookupDeviceType(kw) + "_ManipulatedStatus") == 1
		return true
	EndIf
	return false
EndFunction

; Not sure if that's useful or not? But it will mark the lock as manipulated, so the player can just remove it whenever she wants to.
Bool Function SetLockManipulated(Actor a, Keyword kw)
	if a != PlayerRef || !a.WornHasKeyword(kw)
		return false
	EndIf
	If StorageUtil.SetIntValue(a, "zad_Equipped" + LookupDeviceType(kw) + "_ManipulatedStatus", 1)
		return true
	EndIf
	return false
EndFunction

; Manipulated your lock? Well...it no longer is! The device now behaves as if the locks are fully engaged.
Bool Function SetLockUnManipulated(Actor a, Keyword kw)
	if a != PlayerRef || !a.WornHasKeyword(kw)
		return false
	EndIf
	If StorageUtil.SetIntValue(a, "zad_Equipped" + LookupDeviceType(kw) + "_ManipulatedStatus", 0)
		return true
	EndIf
	return false
EndFunction

; wrapper for the function of same name in the basequest script, so modders can conveniently use it. This is a library version of the animation filter. This function is used to pick a valid sexlab animation to start a new animation with (avoiding filtering in the first place). Includetag can be used to try forcing a given animation tag (e.g. blowjob). This can lead to no valid animations being found, so make sure to try a fallback without forcing tag or aggressive if the return value is None.
; Note: At the time of writing this, there are no bound animations for more than two actors. In other words, the result will -always- be None, if more than two actors are passed to this function and one of them is bound.
sslBaseAnimation[] function SelectValidDDAnimations(Actor[] actors, int count, bool forceaggressive = false, string includetag = "", string suppresstag = "")
	return Config.beltedAnims.FilterQuest.SelectValidDDAnimations(actors, count, forceaggressive, includetag, suppresstag)
EndFunction

; This function can be used to start a scene using valid DD animations. For DD mods, this is the desired method to start a sexlab animation (it's much cleaner than starting a scene if you already know that it's going to be overridden by the filter!)
; It will try various fallbacks to start a scene, and will also make sure that the DD animation filter is bypassed, to increase performance.
; This function will return true if an animation could be started. False otherwise. Caution: This function is not threadsafe, so it will also return false if another call to this function is currently being processed. Use fallbacks!
; if the nofallbacks parameter is set to true, the function will not try any fallbacks (e.g. hiding devices) if no valid animation could be found for the scene and the devices worn.
Bool Function StartValidDDAnimation(Actor[] SexActors, bool forceaggressive = false, string includetag = "", string suppresstag = "", Actor victim = None, Bool allowbed = False, string hook = "", bool nofallbacks = false)
	return Config.BeltedAnims.FilterQuest.StartValidDDAnimation(SexActors, forceaggressive = forceaggressive, includetag = includetag, suppresstag = suppresstag, victim = victim, allowbed = allowbed, hook = hook, nofallbacks = nofallbacks)
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin Generic Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Thanks to lordescobar666 for the method used by these functions:

; Returns the currently equipped inventory device matching the supplied keyword.
Armor Function GetWornDevice(Actor akActor, Keyword kw)
	return zadNativeFunctions.GetWornDevice(akActor,kw)
EndFunction

; Returns the name of a given inventory device
String Function GetDeviceName(armor device)
	return zadNativeFunctions.GetPropertyString(device,"deviceName")
EndFunction

; Finds device based on rendered device keywords (e.g. keyword zad_DeviousBelt also returns a harness)
; Useful for situation where you just want to get the device occupying a specific slot without further differentiation
Armor Function GetWornDeviceFuzzyMatch(Actor akActor, Keyword kw)
    return zadNativeFunctions.GetWornDevice(akActor,kw,true)
EndFunction

; Retrieves correct key for a given inventory device
Key Function GetDeviceKey(armor device)
    return zadNativeFunctions.GetPropertyForm(device,"deviceKey") as Key
EndFunction

; Retrieves device keyword for a given inventory device
Keyword Function GetDeviceKeyword(armor device)
    return zadNativeFunctions.GetPropertyForm(device,"zad_DeviousDevice") as Keyword
EndFunction


; Retrieves rendered device for a given inventory device
; Useful to check for keywords only present on the rendered device
Armor Function GetRenderedDevice(armor device)
    return zadNativeFunctions.GetRenderDevice(device) as Armor
EndFunction

; for the sake of cleaner coding
Bool Function isWearingDeviceType(Actor akActor, Keyword kw)
	return akActor.WornHasKeyword(kw)
EndFunction

Function PlayHornyAnimation(actor akActor)	
	; don't play the animation in combat
	if akActor == playerref && playerref.IsInCombat() 
		return 
	Endif	

  if EnableVRSupport
    PlayThirdPersonAnimation(akActor, "DDZazHornyA", 3, permitRestrictive=true)
  else
	  PlayThirdPersonAnimation(akActor, "DDZazHornyA", 19, permitRestrictive=true)
  EndIf

EndFunction

; simpler function without shaky cam stuff and tie-in to vibration effects.
Function Orgasm(actor akActor)			
	int sID = OrgasmSound.Play(akActor)
	Sound.SetInstanceVolume(sid, Config.VolumeOrgasm)
	Aroused.SetActorExposure(akActor, 10)
	Aroused.UpdateActorOrgasmDate(akActor)
	if !IsAnimating(akActor)
		bool[] cameraState = StartThirdPersonAnimation(akActor, AnimSwitchKeyword(akActor, "Orgasm"), true)
    if EnableVRSupport
		  Utility.Wait(4)
    else
      Utility.Wait(20)
    EndIf
	  EndThirdPersonAnimation(akActor, cameraState, true)
	Else		
	EndIf
EndFunction

Function SendInflationEvent(Actor who, Bool PlugisVaginal, Bool WasInflated, Int PlugState)	
	; Plugstate will contain the current size of the plug, but only for the player. NPCs do not keep track of the state, the value will be -1
	Int Handle = ModEvent.Create("zad_Inflated_Plug")
	If (Handle)		
		ModEvent.PushForm(Handle, who)		
		ModEvent.PushBool(Handle, PlugisVaginal)
		ModEvent.PushBool(Handle, WasInflated)		
		ModEvent.PushInt(Handle, PlugState)		
		ModEvent.Send(Handle)
	Endif	
EndFunction

Function InflateAnalPlug(actor akActor, int amount = 1)	
	If !akActor.WornHasKeyword(zad_kw_InflatablePlugAnal)
		; nothing to do
		return
	EndIf	
	int currentVal = -1
	If akActor == PlayerRef
		currentVal = zadInflatablePlugStateAnal.GetValueInt()
		; only increase the value up to 5, but make it count as an inflation event even if it's maximum inflated
		if currentVal < 5			
			currentVal += amount
			if currentVal > 5
				currentVal = 5
			EndIf
			log("Setting anal plug inflation to " + (currentVal))
			zadInflatablePlugStateAnal.SetValueInt(currentVal)
		EndIf	
		LastInflationAdjustmentAnal = Utility.GetCurrentGameTime()
	EndIf
	SendInflationEvent(akActor, False, True, currentval)
	Aroused.UpdateActorExposure(akActor, 15)
	; this should delay any anims if there is a menu open
	Utility.Wait(0.1)
	; don't play anims if the actor is already in one.
	If IsAnimating(akActor)
		return
	EndIf	
	; don't play the animation in combat if it's the player
	if akActor == playerref && playerref.IsInCombat() 
		return 
	Endif	
	If aroused.GetActorExposure(akActor) < 90 || zadInflatablePlugStateAnal.GetValueInt() < 3
		notify("Your plug makes you more horny...")
		SexlabMoan(akActor)	
		PlayHornyAnimation(akActor)	
	Else
		PlayHornyAnimation(akActor)	
		notify("Your plug sends you over the edge...")
		Orgasm(akActor)
	EndIf
EndFunction

Function InflateVaginalPlug(actor akActor, int amount = 1)	
	If !akActor.WornHasKeyword(zad_kw_InflatablePlugVaginal)
		; nothing to do
		return
	EndIf
	int currentVal = -1
	If akActor == PlayerRef
		currentVal = zadInflatablePlugStateVaginal.GetValueInt()
		; only increase the value up to 5, but make it count as an inflation event even if it's maximum inflated
		if currentVal < 5						
			currentVal += amount
			if currentVal > 5
				currentVal = 5
			EndIf
			log("Setting vaginal plug inflation to " + (currentVal))
			zadInflatablePlugStateVaginal.SetValueInt(currentVal)
		EndIf	
		LastInflationAdjustmentVaginal = Utility.GetCurrentGameTime()
	EndIf
	SendInflationEvent(akActor, True, True, currentval)
	Aroused.UpdateActorExposure(akActor, 15)
	; this should delay any anims if there is a menu open
	Utility.Wait(0.1)
	; don't play anims if the actor is already in one.
	If IsAnimating(akActor)
		return
	EndIf	
	; don't play the animation in combat if it's the player
	if akActor == playerref && playerref.IsInCombat() 
		return 
	Endif	
	If aroused.GetActorExposure(akActor) < 90 || zadInflatablePlugStateVaginal.GetValueInt() < 3
		notify("Your plug makes you more horny...")
		SexlabMoan(akActor)	
		PlayHornyAnimation(akActor)	
	Else
		PlayHornyAnimation(akActor)
		notify("Your plug sends you over the edge...")
		Orgasm(akActor)
	EndIf
EndFunction

Function InflateRandomPlug(actor akActor, int amount = 1)
	; pick one randomly if both are worn:
	If akActor.WornHasKeyword(zad_kw_InflatablePlugVaginal) && akActor.WornHasKeyword(zad_kw_InflatablePlugAnal)
		If Utility.RandomInt(1,2) == 1
			InflateVaginalPlug(akActor, amount)
		Else
			InflateAnalPlug(akActor, amount)
		EndIf
		return
	EndIf
	If akActor.WornHasKeyword(zad_kw_InflatablePlugVaginal)
		InflateVaginalPlug(akActor, amount)
		return
	EndIf
	If akActor.WornHasKeyword(zad_kw_InflatablePlugAnal)
		InflateAnalPlug(akActor, amount)
		return
	EndIf
EndFunction

Function DeflateVaginalPlug(actor akActor, int amount = 1)	
	If !akActor.WornHasKeyword(zad_kw_InflatablePlugVaginal)
		; nothing to do
		return
	EndIf	
	int currentVal = -1
	If akActor == PlayerRef
		currentVal = zadInflatablePlugStateVaginal.GetValueInt()		
		if currentVal > 0
			currentVal -= amount
			if currentVal < 0
				currentVal = 0
			EndIf
			log("Setting vaginal plug inflation to " + (currentVal))
			zadInflatablePlugStateVaginal.SetValueInt(currentVal)
		EndIf	
		LastInflationAdjustmentVaginal = Utility.GetCurrentGameTime()	
	EndIf
	SendInflationEvent(akActor, True, False, currentval)
EndFunction

Function DeflateAnalPlug(actor akActor, int amount = 1)	
	If !akActor.WornHasKeyword(zad_kw_InflatablePlugAnal)
		; nothing to do
		return
	EndIf	
	int currentVal = -1
	If akActor == PlayerRef
		currentVal = zadInflatablePlugStateAnal.GetValueInt()		
		if currentVal > 0
			currentVal -= amount
			if currentVal < 0
				currentVal = 0
			EndIf
			log("Setting anal plug inflation to " + (currentVal))
			zadInflatablePlugStateAnal.SetValueInt(currentVal)
		EndIf	
		LastInflationAdjustmentAnal = Utility.GetCurrentGameTime()	
	EndIf
	SendInflationEvent(akActor, False, False, currentval)
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End Generic Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Function to test an NPC using certain criteria,
bool Function ValidForInteraction(actor currenttest, int genderreq = -1, bool creatureok = false, bool animalok = false, bool beastreaceok = false, bool elderok = false, bool guardok = true)
	log("Checking actor validity for interaction")
	If currenttest.HasKeyword(ActorTypeNPC)		
		log("Processing: " + currenttest.GetLeveledActorBase().GetName() + ". Is NPC.")		
	elseIf currenttest.HasKeyword(ActorTypeCreature) && !currenttest.HasKeyword(ActorTypeAnimal)
		log("Processing: " + currenttest.GetLeveledActorBase().GetName() + ". Is Creature.")		
	elseIf currenttest.HasKeyword(ActorTypeAnimal)		
		log("Processing: " + currenttest.GetLeveledActorBase().GetName() + ". Is Animal.")		
	else		
		log("Processing: " + currenttest.GetLeveledActorBase().GetName() + ". WARNING: Type cannot be determined. Rejected!")
		return false
	endif	
	If IsAnimating(currenttest) || currenttest.GetCurrentScene() != none 		
		log("Rejected: " + currenttest.GetLeveledActorBase().GetName() + ". Reason: Actor is already having sex or is involved in a scene.")		
		return false	
	Endif
	If (currenttest == playerref) || currenttest.IsDisabled() || currenttest.IsDead() || currenttest.isChild() || currenttest.IsGhost() || currenttest.GetActorBase().GetRace() == ManakinRace || currenttest.IsInFaction(currentfollowerfaction) || currenttest.IsPlayerTeammate() || currenttest.HasKeyWord(ActorTypeDwarven) || currenttest.IsInFaction(dunPrisonerFaction)		
		log("Rejected: " + currenttest.GetLeveledActorBase().GetName() + ". Reason: Actor is player character, follower, disabled, child, dwarven construct, a prisoner, or dead.")		
		return false
	endif		
	; if it's an NPC, make sure it's correct gender
	If genderreq > 0
		If currenttest.HasKeyword(ActorTypeNPC) && (currenttest.GetLeveledActorBase().GetSex() != genderreq)
			log("Rejected: " + currenttest.GetLeveledActorBase().GetName() + ". Reason: Actor is wrong gender.")				
			return false			
		EndIf
	EndIf
	; make sure it is not guard, an elder or beast race if they are disallowed
	if currenttest.HasKeyword(ActorTypeNPC) && ((!elderok && currenttest.GetLeveledActorBase().GetRace() == ElderRace) || (!beastreaceok && currenttest.HasKeyword(isBeastRace)) || (!guardok && currenttest.IsInFaction(isGuardFaction)))		
		log("Rejected: " + currenttest.GetLeveledActorBase().GetName() + ". Reason: Actor is disallowed guard/elder/beast race (MCM settings).")		
		return false			
	endif		
	; if it's a creature, make sure they are allowed
	if currenttest.HasKeyword(ActorTypeCreature) && !creatureok					
		log("Rejected: " + currenttest.GetLeveledActorBase().GetName() + ". Reason: Actor is humanoid creature.")			
		Return false		
	endif	
	; if it's a animal, make sure they are allowed
	if currenttest.HasKeyword(ActorTypeAnimal) && !animalok
		log("Rejected: " + currenttest.GetLeveledActorBase().GetName() + ". Reason: Actor is animal.")	
		Return false		
	endif	
	if currenttest.GetWorldSpace() != playerRef.GetWorldSpace()		
		log("Rejected: " + currenttest.GetLeveledActorBase().GetName() + ". Reason: Actor is in different world space than player.")		
		Return false
	endif		
	return true
EndFunction

; This function is for mod consistency mostly
int Function ArousalThreshold(string index)
    ; Want to buy dict
    if index=="Content"
        return 0
    Elseif index=="Desire"
        return 25
    Elseif index=="Horny"
        return 50
    Elseif index=="Desperate"
        return 75
    Else
        Error("Error: ArousalThreshold passed invalid lookup string ("+index+")!")
        return -1
    Endif
EndFunction

; Globally enable periodic event processing.
Function EnableEventProcessing()
	Log("EnableEventProcessing()")
	GlobalEventFlag = True
EndFunction

; Globally disable periodic event processing.
Function DisableEventProcessing()
	Log("DisableEventProcessing()")
	GlobalEventFlag = False
EndFunction

Bool Function AllowGenericEvents(Actor a, Keyword kw)
	if !a.WornHasKeyword(kw)
		return false
	endif
	Armor arm = GetWornRenderedDeviceByKeyword(a, kw)	
	if arm && arm.HasKeyword(zad_BlockGenericEvents)
		return false
	EndIf
	return true
EndFunction

Bool Function HasBreastsExposed(Actor a)
	Form arm = a.GetWornForm(0x00000004)
	if !arm || a.WornHasKeyword(zad_ExposedBreasts)
		return true
	endif
	return false
EndFunction

;====================
; Camera Manipulation
;====================
bool[] Function StartThirdPersonAnimation(actor akActor, string animation, bool permitRestrictive=false)
	Log("StartThirdPersonAnimation("+akActor.GetLeveledActorBase().GetName()+","+animation+")")
	bool[] ret = new bool[2]
	if IsAnimating(akActor)
		Log("Actor already in animating faction.")
		return ret
	EndIf	
	if !IsValidActor(akActor) || (akActor.WornHasKeyword(zad_DeviousArmBinder) && !permitRestrictive)
		Log("Actor is not loaded (Or is otherwise invalid). Aborting.")
		return ret
	EndIf	
	if akActor.IsWeaponDrawn()
		akActor.SheatheWeapon()
		; Wait for users with flourish sheathe animations.
		int timeout=0
		while akActor.IsWeaponDrawn() && timeout <= 35 ;  Wait 3.5 seconds at most before giving up and proceeding.
			Utility.Wait(0.1)
			timeout += 1
		EndWhile
		ret[1] = true
	EndIf
    
    ; actor still have drawn weapon. Starting animation will break the actor weapon state, so we prevent it
    if akActor.IsWeaponDrawn()
        return ret
    endif
	SendDDFunctionEvent ("StartThirdPersonAnimation", akActor)
    
	if akActor == PlayerRef
		; Manipulate camera		
		int cameraOld = Game.GetCameraState()
		if cameraOld == 10 || akActor.IsOnMount(); 10 On a horse
			akActor.Dismount()
			game.ForceThirdPerson()
			int timeout = 0
			while akActor.IsOnMount() && timeout <= 30; Wait for dismount to complete
				Utility.Wait(0.1)
				timeout += 1
			EndWhile
		ElseIf cameraOld == 11; Bleeding out.
			Warn("Actor is bleeding out. Hmm.")
			return ret
		ElseIf cameraOld == 12 ; Dragon? Wtf?
			Warn("Actor is dragon? Not sure what happened here.")
			return ret
		ElseIf cameraOld == 8 || cameraOld == 9 || cameraOld ==  7 ;;; 8 / 9 are third person. 7 is tween menu.
		;
		Else
			ret[0] = true
			game.ForceThirdPerson()
		EndIf		
		; Not sure how to detect auto-walk: Tap 'forward' to disable it if it's active.
		; Unfortunately this work-around causes a CTD for some players, so let's just disable it...
		; Input.TapKey(Input.GetMappedKey("Forward"))
		; Freeze player controls
		DisableControls()
	Else
		akActor.SetDontMove(true)
	EndIf	
	SendDDAnimationEvent(animation, akActor)
	SetAnimating(akActor, true)	
	Debug.SendAnimationEvent(akActor, animation)	
	return ret
EndFunction

; Wrapper for both Start/End third person animation. Use this unless you need more control during the wait period.
Function PlayThirdPersonAnimation(actor akActor, string animation, int duration, bool permitRestrictive=false)
	Log("PlayThirdPersonAnimation("+akActor.GetLeveledActorBase().GetName()+","+animation+","+duration+")")
	if IsAnimating(akActor)
		Log("Actor already in animating faction.")
		return
	EndIf
	if SexLab.ValidateActor(akActor) < 0 || akActor.IsSwimming() || akActor.IsOnMount() || akActor.GetCurrentScene() != none || akActor.GetSitState() != 0
		Warn("Not playing third person animation: Actor is already in a blocking animation.")
		return
	EndIf
	bool[] cameraState=StartThirdPersonAnimation(akActor, animation, permitRestrictive=permitRestrictive)
	Log("Playing animation for "+duration+" seconds.")
	SendDDFunctionEvent ("PlayThirdPersonAnimation", akActor)
	Utility.Wait(duration)
	EndThirdPersonAnimation(akActor, cameraState, permitRestrictive=permitRestrictive)
EndFunction


Function EndThirdPersonAnimation(actor akActor, bool[] cameraState, bool permitRestrictive=false)
	Log("EndThirdPersonAnimation( " + akActor.GetLeveledActorBase().GetName() + "," + cameraState[0] + ")" )
	SetAnimating(akActor, false)
	if (!akActor.Is3DLoaded() ||  akActor.IsDead() || akActor.IsDisabled())
		Log("Actor is not loaded (Or is otherwise invalid). Aborting.")
		return
	EndIf
	; Reset idle 
	Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
	if akActor == PlayerRef
		UpdateControls()
		if cameraState[0]
			game.ForceFirstPerson()		
		EndIf
	Else
		akActor.SetDontMove(false)
	EndIf
	SendDDFunctionEvent ("EndThirdPersonAnimation", akActor)	
EndFunction


float Function GetVersion()
	return 14 ; build number increment to determine the newest version - does NOT correspond with the offical version name. Returns a float not to mess with existing implementations of this function.
EndFunction

String Function GetVersionString()
	return "5.2-NG" ; string to be displayed in MCM etc.
EndFunction



;===============================================================================
; Internal Functions
;===============================================================================
Function StoreExposureRate(actor akActor)
	float original = StorageUtil.GetFloatValue(akActor, "zad.StoredExposureRate", 0.0)
	if original <= 0
		float exposureRate = Aroused.GetActorExposureRate(akActor)
		if exposureRate <= 0
			Warn("Exposure rate was originally 0. Changing to default.")
			exposureRate = Aroused.slaConfig.DefaultExposureRate
		Endif
		StorageUtil.SetFloatValue(akActor, "zad.StoredExposureRate", exposureRate)
	else
		Warn("StoreExposureRate called for actor " + akActor.GetLeveledActorBase().GetName() +", but actor already has this information stored.")
	Endif
EndFunction


float Function GetOriginalRate(actor akActor)
	return StorageUtil.GetFloatValue(akActor, "zad.StoredExposureRate", Aroused.slaConfig.DefaultExposureRate)
EndFunction


float Function GetModifiedRate(actor akActor)
	if akActor.WornHasKeyword(zad_DeviousPlug)
		return (GetOriginalRate(akActor) * GetPlugRateMult())
	Elseif akActor.WornHasKeyword(zad_DeviousBelt)
		return (GetOriginalRate(akActor) * GetBeltRateMult())
	Else
		Warn("GetModifiedRate() returning original rate: Actor is not belted.")
		return GetOriginalRate(akActor)
	Endif
EndFunction

bool function CheckConfigInit()
	if Config == none 
		Error("Config is not initialized. User didn't update properly?")
		return false
	EndIf
	return true
EndFunction

float function GetPlugRateMult()
	if CheckConfigInit()
		return Config.PlugRateMult
	else
		Error("GetPlugRateMult returning -1")
		return -1
	EndIf
EndFunction

float function GetBeltRateMult()
	if CheckConfigInit()
		return Config.BeltRateMult
	else
		Error("GetBeltRateMult returning -1")
		return -1
	EndIf
EndFunction

Function Notify(string out, bool messageBox=false)
	if messageBox
		Debug.MessageBox(out)
	else
		Debug.Notification(out)
	EndIf
EndFunction


Function NotifyNPC(string out, bool messageBox=false)
	if Config.NpcMessages
		Notify(out, messageBox)
	else
		Log("NpcMessages==false: "+out)
	EndIf
EndFunction


Function NotifyPlayer(string out, bool messageBox=false)
	if Config.PlayerMessages
		Notify(out, messageBox)
	else
		Log("PlayerMessages==false: " + out)
	EndIf
EndFunction


Function NotifyActor(string out, Actor akActor, bool messageBox=false)
	if akActor == PlayerRef
		NotifyPlayer(out, messageBox)
	else
		NotifyNPC(out, messageBox)
	EndIf
EndFunction


Function Log(string in, int level=0)
	if !Config.LogMessages
		return
	EndIf
	string out = "[Zad-NG]"
	if level>=2
		Debug.Trace("============================================================")
		Debug.Trace(out + " (((ERROR))): " + in)
		Debug.Trace("============================================================")
		return
	elseif level==1
		out = out + " ((WARNING)): " + in
	elseif level==0
		out = out + ": " + in
	Endif
	Debug.Trace(out)
EndFunction


Function Warn(string in)
	Log(in,1)
EndFunction


Function Error(string in)
	Log(in,2)
	Debug.MessageBox("An error has ocurred with your installation of Devious Devices. Please check the log for more information. Error Text: "+in)
EndFunction


bool Function WearingConflictingDevice(actor akActor, armor deviceRendered, keyword zad_DeviousDevice)
	if akActor == none
		Error("WearingConflictingDevice received none argument.")
	EndIf
	if akActor.GetItemCount(deviceRendered)==0 && akActor.WornHasKeyword(zad_DeviousDevice)
		return true
	Endif
	return false
EndFunction


; Wrapper function for smaller arousal increments
Function UpdateExposure(actor akRef, float val, bool skipMultiplier=false)
	If (akRef == None)
		Error("UpdateExposure passed none reference.")
		return
	EndIf
	float lastRank = Aroused.GetActorExposure(akRef)
	Log("UpdateExposure("+akRef+","+val+","+skipMultiplier+")")
	if skipMultiplier
		; This function is very slow, and sometimes hangs for multiple seconds (Seen 10+). Directly access internals as a work-around.
		; Aroused.SetActorExposure(akRef, (lastRank + val + 1) as Int)
		float newVal = lastRank + val
		if newVal > 100
			newVal = 100
		EndIf

		;OSL Aroused compatibility patch
		if Config.GotOSLA 											
			Aroused.SetActorExposure(akRef, (newVal + 1) as int)
		else 														
			StorageUtil.SetFloatValue(akRef, "SLAroused.ActorExposure", newVal)
			StorageUtil.SetFloatValue(akRef, "SLAroused.ActorExposureDate", Utility.GetCurrentGameTime())
		endif
		
	Else
		float rate = Aroused.GetActorExposureRate(akRef)
		int newRank = (lastRank + (val as float) * rate) as int	
		Aroused.SetActorExposure(akRef, newRank)
	EndIf
EndFunction


;;;
Function AcquireAndSpinlock()
	if DeviceMutex
		log("SpinLock() Started.")
		int timeout = 0
		while DeviceMutex
			Utility.Wait(0.1)
			if timeout >= 150
				Warn("SpinLock() timed out.")
				deviceMutex = false
			EndIf
			timeout += 1
		EndWhile
		log("SpinLock() Completed. Cycles:" + timeout)
	EndIf
	DeviceMutex = true ; Immediately reacquire lock
EndFunction


Function SendDeviceRemovalEvent(string deviceName, actor akActor)
	int isPlayer = 0
	if akActor == PlayerRef
		isPlayer = 1
	EndIf
	SendDeviceEvent("DeviceRemoved"+deviceName, akActor.GetLeveledActorBase().GetName(), isPlayer)
EndFunction

Function SendDeviceEquippedEvent(string deviceName, actor akActor)
	int isPlayer = 0
	if akActor == PlayerRef
		isPlayer = 1
	EndIf
	SendDeviceEvent("DeviceEquipped"+deviceName, akActor.GetLeveledActorBase().GetName(), isPlayer)
EndFunction

Function SendDeviceEvent(string eventName, string actorName, int isPlayer)
	Log("Sending device event "+eventName+"("+actorName+":"+isPlayer+")")
	SendModEvent(eventName, actorName, isPlayer)
EndFunction

; these events will communicate the exact item that was manipulated, so 3rd party mods don't have to register 15+ different events to catch every conceivable DD item type.
Function SendDeviceEquippedEventVerbose(armor inventoryDevice, keyword deviceKeyword, actor akActor)	
	Int Handle = ModEvent.Create("DDI_DeviceEquipped")
	If (Handle)		
		ModEvent.PushForm(Handle, inventoryDevice)
		ModEvent.PushForm(Handle, deviceKeyword)
		ModEvent.PushForm(Handle, akActor)		
		ModEvent.Send(Handle)
	Endif	
	Int InvUniqueId=nioverride.GetObjectUniqueID(inventoryDevice)
	
	Int RenderUniqueId=nioverride.GetObjectUniqueID(GetRenderedDevice(inventoryDevice))
	if (InvUniqueId==0)
		return
	EndIf
	if (RenderUniqueId==0)
		return
	EndIf
	Int MaskIndex=0
	Int MaxMaskIndex=Game.GetNumTintMasks()
	nioverride.EnableTintTextureCache()
	While (MaskIndex < MaxMaskIndex)
		nioverride.SetItemDyeColor(RenderUniqueId,MaskIndex,nioverride.GetItemDyeColor(InvUniqueId,MaskIndex))
		MaskIndex=MaskIndex+1
	EndWhile
	nioverride.UpdateItemDyeColor(akActor,RenderUniqueId)
	nioverride.ReleaseTintTextureCache()
EndFunction

Function SendDeviceRemovedEventVerbose(armor inventoryDevice, keyword deviceKeyword, actor akActor)
	Int Handle = ModEvent.Create("DDI_DeviceRemoved")
	If (Handle)		
		ModEvent.PushForm(Handle, inventoryDevice)
		ModEvent.PushForm(Handle, deviceKeyword)
		ModEvent.PushForm(Handle, akActor)		
		ModEvent.Send(Handle)
	Endif
EndFunction

Function SendDeviceKeyBreakEventVerbose(armor inventoryDevice, keyword deviceKeyword, actor akActor)	
	Int Handle = ModEvent.Create("DDI_KeyBreak")
	If (Handle)		
		ModEvent.PushForm(Handle, inventoryDevice)
		ModEvent.PushForm(Handle, deviceKeyword)
		ModEvent.PushForm(Handle, akActor)		
		ModEvent.Send(Handle)
	Endif	
EndFunction

Function SendDeviceJamLockEventVerbose(armor inventoryDevice, keyword deviceKeyword, actor akActor)	
	Int Handle = ModEvent.Create("DDI_JamLock")
	If (Handle)		
		ModEvent.PushForm(Handle, inventoryDevice)
		ModEvent.PushForm(Handle, deviceKeyword)
		ModEvent.PushForm(Handle, akActor)		
		ModEvent.Send(Handle)
	Endif	
EndFunction

Function SendDeviceEscapeEvent(armor inventoryDevice, keyword deviceKeyword, bool successful)	
	Int Handle = ModEvent.Create("DDI_DeviceEscapeAttempt")
	If (Handle)		
		ModEvent.PushForm(Handle, inventoryDevice)
		ModEvent.PushForm(Handle, deviceKeyword)
		ModEvent.PushBool(Handle, successful)		
		ModEvent.Send(Handle)
	Endif	
EndFunction

; Terminate signal for content mods
; Do NOT trigger this signal from DD content mods. It's for framework use ONLY!!!
Function SendQuestSigTerm()	
	Int Handle = ModEvent.Create("DDI_Quest_SigTerm")
	If (Handle)		
		ModEvent.Send(Handle)
	Endif	
EndFunction

;Fired when specific functions that can interupt scene/quest flows
Function SendDDFunctionEvent (string FunctionName,actor akActor)	
	Int Handle = ModEvent.Create("DDI_FunctionCalled")
	If (Handle)	
		ModEvent.PushString(Handle, FunctionName)
		ModEvent.PushForm(Handle, akActor)		
		ModEvent.Send(Handle)
	Endif	
EndFunction

;Fired when specific animation is started
Function SendDDAnimationEvent(string animation,actor akActor)	
	Int Handle = ModEvent.Create("DDI_AnimationStarted")
	If (Handle)
		ModEvent.PushString(Handle, animation)
		ModEvent.PushForm(Handle, akActor)		
		ModEvent.Send(Handle)
	Endif	
EndFunction

FormList Property zadTemporaryDeviceStorage Auto
; Remove broken DD items from the player. 
Function DDI_DebugFixDevices()
	log("DDI_DebugFixDevices called. Attempting to fix broken devices.")
	Armor idevice = None
	Armor rdevice = None
	Form kForm = None
	Int RemovedItems = 0
	zadTemporaryDeviceStorage.Revert()
	Int i = PlayerRef.GetNumItems()
	bool clearAll = True
	While i > 0			
		i -= 1
		kForm = PlayerRef.GetNthForm(i)	
		If (kForm As Armor)
			if kForm.HasKeyword(zad_InventoryDevice) && PlayerRef.IsEquipped(kForm)
				idevice = kForm As Armor
				if idevice
					ObjectReference tmpORef = PlayerRef.placeAtMe(kForm, abInitiallyDisabled = true)
					zadEquipScript tmpZRef = tmpORef as zadEquipScript
					if tmpZRef != none && PlayerRef.GetItemCount(tmpZRef.deviceRendered) > 0
						rdevice = tmpZRef.deviceRendered as Armor
						zadTemporaryDeviceStorage.AddForm(rdevice)
						clearAll = False
					Endif
					tmpORef.delete()
				Endif
			Endif
		Endif
	EndWhile
	i = PlayerRef.GetNumItems()
	While i > 0			
		i -= 1
		kForm = PlayerRef.GetNthForm(i)
		if (kForm As Armor)
			if kForm.HasKeyword(zad_Lockable) && !kForm.HasKeyword(zad_InventoryDevice)
				Int c = PlayerRef.GetItemCount(kForm)
				if clearAll
					PlayerRef.RemoveItem(kForm,c,true)
				else
					Int j = zadTemporaryDeviceStorage.GetSize()
					bool removeRendered = True
					while j > 0
						j -= 1
						rdevice = zadTemporaryDeviceStorage.GetAt(j) as Armor
						if rdevice == kForm
							removeRendered = False
						EndIf
					EndWhile
					if removeRendered
						PlayerRef.RemoveItem(kForm,c,true)
						RemovedItems += c
					elseif c > 1
						c = c - 1
						PlayerRef.RemoveItem(kForm,c,true)
						RemovedItems += c
					Endif
				Endif
			Endif
		Endif
	EndWhile
	Notify("DDI Debug broken item removal completed, " + RemovedItems + " items removed.", MessageBox = False)
	zadTemporaryDeviceStorage.Revert()
	;Utility.Wait(1)
EndFunction

; Remove all items from the player. For debug purposes ONLY! And I -really- don't want to see a DD content mod calling this function from outside the framework, or providing a function like it. It's for framework use ONLY!!!!!
Function DDI_DebugTerminate()
	; This function is intentionally slower than it could be. It's meant to be used for debug situations only.
	log("DDI_DebugTerminate called. Removing devices.")
	Notify("DDI Debug Terminate signal triggered.\nAttempting to clear all DD items, including quest devices.", MessageBox = True)	
	Utility.Wait(1)
	Armor idevice = None
	Armor rdevice = None
	Keyword kw = None
	Keyword token = None
	if !PlayerRef.WornHasKeyword(zad_Lockable)
		; no DD items equipped, can abort here
		Notify("No DD items found on the player. Aborting.", MessageBox = True)	
		return
	endif			
	Int i = PlayerRef.GetNumItems()
	While i > 0			
		i -= 1
		Form kForm = PlayerRef.GetNthForm(i)	
		If (kForm As Armor)
			if kForm.HasKeyword(zad_InventoryDevice)
				idevice = kForm As Armor
				if idevice
					rdevice = GetRenderedDevice(idevice)
					kw = GetDeviceKeyword(idevice)
					If idevice && rdevice && kw
						; we got a valid DD item here, let's remove it
						If idevice.HasKeyword(zad_QuestItem) || rdevice.HasKeyword(zad_QuestItem)
							; It's a quest item, so we need a token to pass the checks. This is the only way I am aware of to remove 3rd party quest items. And again, I don't want to see content mods doing that.
							Int k = rdevice.GetNumKeywords()
							Bool done = false
							Keyword dKeyword
							While k > 0 && !done
								k -= 1
								dKeyword = rdevice.GetNthKeyword(k)
								if dKeyword && !zadStandardKeywords.HasForm(dKeyword)
									token = dKeyword
									done = true
								EndIf	
							EndWhile
							if token
								RemoveQuestDevice(PlayerRef, idevice, rdevice, kw, token, destroyDevice = true, skipMutex = true)
							EndIf
						Else
							removeDevice(PlayerRef, idevice, rdevice, kw, destroyDevice = true, skipevents = false, skipmutex = true)			
						EndIf
						Utility.Wait(1)
					EndIf
				Endif			
			EndIf
		EndIf
	EndWhile
	Notify("DDI Debug item removal completed. Sending SigTerm to content mods.", MessageBox = True)	
	Utility.Wait(1)
	SendQuestSigTerm()
EndFunction


;==================================================
; Effects
;==================================================

function Masturbate(actor a, bool feedback = false)	
	sslBaseAnimation[] Manims 
	If a == PlayerRef && feedback
		NotifyPlayer("You cannot resist your urges anymore!")
	Else
		If a.GetLeveledActorBase().GetSex() == 1 && feedback
			NotifyPlayer(a.GetLeveledActorBase().GetName() + " can't resist her urges anymore...")
		ElseIf a.GetLeveledActorBase().GetSex() == 0 && feedback
			NotifyPlayer(a.GetLeveledActorBase().GetName() + " can't resist his urges anymore...")
		Endif
	EndIf	
	If a.WornHasKeyword(zad_DeviousArmbinder)
		Manims = New sslBaseAnimation[1]
		Manims[0] = SexLab.GetAnimationObject("DDArmbinderSolo")
	ElseIf a.WornHasKeyword(zad_DeviousYoke)
		Manims = New sslBaseAnimation[1]
		Manims[0] = SexLab.GetAnimationObject("DDYokeSolo")
	ElseIf a.WornHasKeyword(zad_DeviousArmbinderElbow)
		Manims = New sslBaseAnimation[1]
		Manims[0] = SexLab.GetAnimationObject("DDElbowbinderSolo")
	ElseIf a.WornHasKeyword(zad_DeviousYokeBB)
		Manims = New sslBaseAnimation[1]
		Manims[0] = SexLab.GetAnimationObject("DDBBYokeSolo")
	ElseIf a.WornHasKeyword(zad_DeviousCuffsFront)
		Manims = New sslBaseAnimation[1]
		Manims[0] = SexLab.GetAnimationObject("DDFrontCuffsSolo")
	ElseIf a.WornHasKeyword(zad_DeviousElbowTie)
		Manims = New sslBaseAnimation[1]
		Manims[0] = SexLab.GetAnimationObject("DDElbowTieSolo")
	;use this animation if the character has a chastity belt on
	;or has a harness on, her hands are not bound and the harness is crotchless - since there is also this variant since DD5.1
	Elseif ( a.WornHasKeyword(zad_DeviousBelt) || a.WornHasKeyword(zad_DeviousHarness) ) && !a.WornHasKeyword(zad_DeviousHeavyBondage) && !a.WornHasKeyword(zad_PermitVaginal)
		Manims = New sslBaseAnimation[1]
		Manims[0] = SexLab.GetAnimationObject("DDBeltedSolo")
	Elseif a.WornHasKeyword(zad_DeviousHeavyBondage)
		; play bound animation for other restraints
		PlayHornyAnimation(a)
		return
	Else
		If a.GetLeveledActorBase().GetSex() == 1
			Manims = SexLab.GetAnimationsByTag(1, "Solo", "F", requireAll=true)
		Else
			Manims = SexLab.GetAnimationsByTag(1, "Solo", "M", requireAll=true)
		Endif
	Endif
	actor[] tmp = new actor[1]
	tmp[0] = a
	SexLab.StartSex(tmp, Manims)
EndFunction


;Event DeviceActorOrgasmExp example
;*   ScriptName SomeScript extends ParentScript
;*
;*   Event OnInit()
;*       RegisterForModEvent("DeviceActorOrgasmExp","ReceiveFunction")
;*   EndEvent
;*
;*   Function ReceiveFunction(Form akSource,Form akFormActor,Int aiSetArousal)
;*      Actor akActor = akFormActor as Actor
;*      ;process function
;*   EndFunction
Function SendOrgasmEvent(Actor akActor, int aiArousalSet = -1)
    SendModEvent("DeviceActorOrgasm", akActor.GetLeveledActorBase().GetName())
    
    ;new event
    Int loc_handle = ModEvent.Create("DeviceActorOrgasmEx")
    if loc_handle
        ModEvent.PushForm(loc_handle, self)         ;Event source (zadlibs), in case that some other mode might call this function from different place
        ModEvent.PushForm(loc_handle, akActor)      ;Actor
        ModEvent.PushInt(loc_handle, aiArousalSet)  ;Arousal after orgasm
        ModEvent.Send(loc_handle)
    endif
EndFunction

; Cause actor to have an orgasm.
;;; Function ActorOrgasm(actor akActor, int setArousalTo=-1, int vsID=-1)
;;;             actor akActor, ; The actor to operate on.
;;;             int setArousalTo=-1, ; The arousal value the actor should be set to post-orgasm
;;;             int vsID=-1, ; Vibrating sound ID. If provided, will stop vibration sound.
Function ActorOrgasm(actor akActor, int setArousalTo=-1, int vsID=-1)
	;SendModEvent("DeviceActorOrgasm", akActor.GetLeveledActorBase().GetName())
    SendOrgasmEvent(akActor,setArousalTo)
	if setArousalTo < 0
		setArousalTo = Utility.RandomInt(0, 75)
	EndIf
	int sID = OrgasmSound.Play(akActor)
	Sound.SetInstanceVolume(sid, Config.VolumeOrgasm)
	Aroused.SetActorExposure(akActor, setArousalTo)
	Aroused.UpdateActorOrgasmDate(akActor)
	if !IsAnimating(akActor)
		bool[] cameraState = StartThirdPersonAnimation(akActor, AnimSwitchKeyword(akActor, "Orgasm"), true)
		int i = 0
		while i < 20
			i+= 1
			if !IsVibrating(akActor) && vsID != -1
				Sound.StopInstance(vsID)
				vsID=-1
			EndIf
			Utility.Wait(1)
		EndWhile
	        EndThirdPersonAnimation(akActor, cameraState, true)
	Else
		if !IsVibrating(akActor) && vsID != -1
			Sound.StopInstance(vsID)
			vsID=-1
		EndIf
	EndIf
EndFunction

; Play panting sound from actor
Function Pant(actor akActor)
	int psID = ShortPantSound.Play(akActor)
	Sound.SetInstanceVolume(psID, 1)
EndFunction

;;; wrapper for Sexlab Aroused integrated / gag integrated moan.
Function SexlabMoan(actor akActor, int arousal=-1, sslBaseVoice voice = none)
	; Is the player gagged?
	if akActor.WornHasKeyword(zad_DeviousGag)
		int gsID = gaggedSound.Play(akActor)
		Sound.SetInstanceVolume(gsID, 1)
		return
	EndIf
	; Select voice if needed
	if !voice
		voice = SexLab.PickVoice(akActor)
	EndIf
	; If arousal isn't provided, look it up.
	if arousal == -1
		arousal = Aroused.GetActorExposure(akActor)
	EndIf
	; Play the voice.
	voice.Moan(akActor, arousal)
EndFunction

; Play non-sexlab-moans
Function Moan(actor akActor, int arousal=-1, sslBaseVoice voice = none)
	if akActor.WornHasKeyword(zad_DeviousGag)
		int gsID = gaggedSound.Play(akActor)
		Sound.SetInstanceVolume(gsID, 1)
	Else
		int msID = ShortMoanSound.Play(akActor)
		Sound.SetInstanceVolume(msid, 1)
	EndIf
EndFunction


bool Function PlaySceneAndWait(Scene toPlay, bool forceStart=false, int timeout=120, int increment=5)
	if forceStart
		toPlay.ForceStart()
	else
		toPlay.Start()
	EndIf
	int i = 0
	while toPlay.IsPlaying() && i < timeout
		i += increment
		Utility.Wait(increment)
	EndWhile
	if i >= timeout
		if toPlay.IsPlaying()
			toPlay.Stop()
		EndIf
		Log("Scene timed out.")
		return false
	EndIf
	return true
EndFunction


;Event DeviceEdgedActorEx example
;*   ScriptName SomeScript extends ParentScript
;*
;*   Event OnInit()
;*       RegisterForModEvent("DeviceEdgedActorEx","ReceiveFunction")
;*   EndEvent
;*
;*   Function ReceiveFunction(Form akSource,Form akFormActor)
;*      Actor akActor = akFormActor as Actor
;*      ;process function
;*   EndFunction
Function SendEdgeEvent(Actor akActor)
    SendModEvent("DeviceEdgedActor", akActor.GetLeveledActorBase().GetName())
    
    ;new event
    Int loc_handle = ModEvent.Create("DeviceEdgedActorEx")
    if loc_handle
        ModEvent.PushForm(loc_handle, self)         ;Event source (zadQuest), in case that some other mode might call this function from different place
        ModEvent.PushForm(loc_handle, akActor)      ;Actor
        ModEvent.Send(loc_handle)
    endif
EndFunction

; Cause an actor to experience being edged.
Function EdgeActor(actor akActor)
	;SendModEvent("DeviceEdgedActor", akActor.GetLeveledActorBase().GetName())
    SendEdgeEvent(akActor)
	int sID = EdgedSound.Play(akActor)
	Sound.SetInstanceVolume(sid, Config.VolumeEdged)
  if EnableVRSupport
  	PlayThirdPersonAnimation(akActor, AnimSwitchKeyword(akActor, "Edged"), 3, permitRestrictive=true)
  else
    PlayThirdPersonAnimation(akActor, AnimSwitchKeyword(akActor, "Edged"), 19, permitRestrictive=true)
  EndIf
EndFunction


float Function GetMoanVolume(actor akActor, int exposure = -1)
	if akActor == PlayerRef
		if exposure == -1
			exposure = Aroused.GetActorExposure(akActor)
		EndIf
		return (0.25 + (exposure * 0.005) as Int)
	Else
		return 0.20 ; Quiet breathing for moaning actors.
	EndIf
EndFunction


;====================================================================
;=====================REWORKED EXPRESSION SYSTEM=====================
;====================================================================
; Vib Expressions
Function ApplyExpression(Actor akActor, sslBaseExpression expression, int strength, bool openMouth=false)
	if !expression
		Log("ApplyExpression(): Expression is none.")
		return
	EndIf
	;use priority 0, as its impossible to know what priority should be used
	ExpLibs.ApplyExpression(akActor, expression, strength, openMouth,aiPriority = 0)
EndFunction

;reset expression with priority 0
Function ResetExpression(actor akActor, sslBaseExpression expression)
	ExpLibs.ResetExpressionRaw(akActor,aiPriority = 0)
EndFunction

;reworked function ApplyExpression to use expression priority
Function ApplyExpression_v2(Actor akActor, sslBaseExpression expression,int iPriority, int strength = 100,bool openMouth=false)
	if !expression
		Log("ApplyExpression(): Expression is none.")
		return
	EndIf
	ExpLibs.ApplyExpression(akActor, expression, strength, openMouth,iPriority)
EndFunction

;Wrapper for ApplyExpressionRaw function
Function ApplyExpressionRaw(Actor akActor, float[] expression ,int iPriority, int strength = 100,bool openMouth=false)
	ExpLibs.ApplyExpressionRaw(akActor, expression, strength, openMouth,iPriority)
EndFunction
;reset expression with passed priority
Function ResetExpressionRaw(actor akActor, int iPriority)
	ExpLibs.ResetExpressionRaw(akActor,iPriority)
EndFunction

;====================================================================
;====================================================================
;====================================================================

string function GetVibrationStrength(int vibStrength)
	if vibStrength == 5
		return "extremely powerfully"
	elseIf vibStrength == 4
		return "strongly"
	elseIf vibStrength == 3
		return ""
	elseIf vibStrength == 2
		return "softly"
	elseIf vibStrength == 1
		return "agonizingly softly"
	EndIf
	return "Invalid"
EndFunction


string Function BuildVibrationString(actor akActor, int vibStrength, bool vPlug, bool aPlug, bool vPiercings, bool nPiercings)
	if ((vPiercings || nPiercings) && (vPlug || aPlug))
		return "Your piercing(s) (In addition to the plug(s) within you) begin to vibrate " + GetVibrationStrength(vibStrength) + "!"
	ElseIf ((vPiercings) && !(vPlug || aPlug))
		return "Your clitoral piercing begins to vibrate " + GetVibrationStrength(vibStrength) + "!"
	ElseIf ((nPiercings) && !(vPlug || aPlug))
		return "Your nipple piercings begins to vibrate " + GetVibrationStrength(vibStrength) + "!"
	Else
		return "The plug(s) within you begin to vibrate " + GetVibrationStrength(vibStrength) + "!"
	EndIf
EndFunction

string Function BuildPostVibrationString(actor akActor, int vibStrength, bool vPlug, bool aPlug, bool vPiercings, bool nPiercings)
	bool desperate = (Aroused.GetActorExposure(akActor) >= ArousalThreshold("Desperate"))
	if ((vPiercings || nPiercings) && (vPlug || aPlug))
		if Desperate
			return "You let out a frustrated moan as your piercing and plugs abruptly cease to vibrate."
		Else
			return "Your piercings and plugs all cease to vibrate."
		EndIf
	ElseIf ((vPiercings) && !(vPlug || aPlug))
		if Desperate
			return "You let out a frustrated moan as your clitoral piercing ceases to vibrate."
		Else
			return "Your clitoral piercing ceases to vibrate."
		EndIf
	ElseIf ((nPiercings) && !(vPlug || aPlug))
		if Desperate
			return "You breathe a sigh of relief when the rings piercing your nipples cease to vibrate."
		Else
			return "Your nipple piercings cease to vibrate."
		Endif
	Else
		if Desperate
			return "Your pussy clenches around the plugs as they abruptly cease vibrating."
		Else
			return "The plugs cease vibrating."
		EndIf
	EndIf
EndFunction

;;; Returns number of times actor came from this effect, -1 if it edged them, or -2 if an event was already ongoing.
; This function has suffered from feature creep pretty hard since it's inception, and is in need of refactoring. Still works, but very messy.
; Will split this up to a small library in the future. Will document this properly at that point.
; Parameters are persitant in pex files. 2-stage function call to avoid breaking older mods.
; This is the old signature of the function, and is needed for backwards compatibility
int Function VibrateEffect(actor akActor, int vibStrength, int duration, bool teaseOnly=false, bool silent = false)
    return VibrateEffectV2(akActor, vibStrength, duration, teaseOnly, silent, AllowActorInScene = false)
EndFunction

; V2 This one allows more fine-tuned control by allowing callers to consider actors in scenes as valid
int Function VibrateEffectV2(actor akActor, int vibStrength, int duration, bool teaseOnly=false, bool silent = false, Bool AllowActorInScene = false)
	; don't execute this function if the character is in combat. Nobody in their right mind starts playing with herself if there are people trying to kill her.
	; Events that otherwise would call this function are responsible for providing alternatives as desired.
	if akActor == PlayerRef && playerref.IsInCombat()
        Log("Vibrate effect called on Player, but player is in combat. Don't start VibrateEffect.")
		return -2
	Endif
	if !IsValidActorV2(akActor, AllowActorInScene)
		Log("Actor is not valid. Don't start VibrateEffect.")
		return -2
	EndIf
	AcquireAndSpinlock()
	If duration == 0
		duration = Utility.RandomInt(5,20)
	EndIf
	bool wasVibrating = IsVibrating(akActor)
	int newDuration = GetVibrating(akActor) + duration
	SetVibrating(akActor, newDuration)
	if wasVibrating
		Log("Actor already in VibratorFaction. Extending duration of existing event: "+newDuration)
		deviceMutex = False
		return -2
	EndIf

	bool vPlug = akActor.WornHasKeyword(zad_DeviousPlugVaginal)
	bool aPlug = akActor.WornHasKeyword(zad_DeviousPlugAnal)
	bool nPiercings = akActor.WornHasKeyword(zad_DeviousPiercingsNipple )
	bool vPiercings = akActor.WornHasKeyword(zad_DeviousPiercingsVaginal )

	deviceMutex = False
	float numVibratorsMult = 0.0
	;;; Plugs
	if vPlug
		numVibratorsMult += 0.7
	EndIf
	if aPlug
		numVibratorsMult += 0.3
	EndIf
	;;; Piercings
	if nPiercings
		numVibratorsMult += 0.25
	EndIf
	if vPiercings
		numVibratorsMult += 0.5
	EndIf

	if numVibratorsMult == 0.0
		numVibratorsMult = 1
	EndIf
	if akActor.WornHasKeyword(zad_DeviousBlindfold) ; Increased sensitivity!
		numVibratorsMult *= 1.15
	EndIf
	if !wasVibrating
		SendModEvent("DeviceVibrateEffectStart", akActor.GetLeveledActorBase().GetName(), vibStrength * numVibratorsMult)
	EndIf
	int actorCame = 0
	Log("VibrateEffect("+vibStrength +" for "+duration+"). VibrateMult: "+numVibratorsMult)
	sound vibSoundSelect
	
	string msg = BuildVibrationString(akActor, vibStrength, vPlug, aPlug, vPiercings, nPiercings)
	if vibStrength == 5
		vibSoundSelect = VibrateVeryStrongSound
	elseIf vibStrength == 4
		vibSoundSelect = VibrateStrongSound
	elseIf vibStrength == 3
		vibSoundSelect = VibrateStandardSound
	elseIf vibStrength == 2
		vibSoundSelect = VibrateWeakSound
	elseIf vibStrength == 1
		vibSoundSelect = VibrateVeryWeakSound
	else
		Error("Vibrator received invalid strength setting.")
		return -2
	EndIf
	if !silent && akActor == PlayerRef
		NotifyPlayer(msg)
	Endif

	; Initialize Sounds
	float vibSoundVol = Config.VolumeVibrator
	if akActor != PlayerRef
		vibSoundVol = Config.VolumeVibratorNPC
	EndIf
	int vsID = vibSoundSelect.Play(akActor)
	Sound.SetInstanceVolume(vsID, vibSoundVol)
	int msID = MoanSound.Play(akActor)
	Sound.SetInstanceVolume(msID, GetMoanVolume(akActor))
	int timeVibrated = 0
	int vibAnimStarted = 0
	bool[] cameraState

	; Start base expression
	sslBaseExpression expression = SexLab.RandomExpressionByTag("Pleasure")
	ApplyExpression_v2(akActor, expression, 15, Math.Ceiling(Aroused.GetActorExposure(akActor)*0.6), openMouth=false) ;do not open mouth
	if Utility.RandomInt() <= (10*vibStrength)
    if !EnableVRSupport
		  PlayThirdPersonAnimation(akActor, AnimSwitchKeyword(akActor, "Horny"), 3, permitRestrictive=true)
    EndIf
	EndIf
	
	; Actor in combat?
	float combatModifier = 1
	if (akActor.GetCombatState() != 0)
		combatModifier = 0.5
	EndIf

	; Main Loop
	While IsValidActorV2(akActor, AllowActorInScene) && timeVibrated < GetVibrating(akActor) && (akActor.WornHasKeyword(zad_DeviousPlug) || akActor.WornHasKeyword(zad_DeviousPiercingsNipple) || akActor.WornHasKeyword(zad_DeviousPiercingsVaginal))
		; Log("XXX VibrateEffect: Begin Tick "+timeVibrated)
		if (timeVibrated % 2) == 0 ; Make noise
			; Log("XXX VibrateEffect: Making Noise")
		 	akActor.CreateDetectionEvent(akActor, vibStrength * 10)
			; Log("XXX VibrateEffect: Done Making Noise")
		EndIf
		;;;;;;;;;;
		; Let the actor cum?
		;;;;;;;;;;
		; Log("XXX VibrateEffect: Let the actor cum?")
		if timeVibrated >= 3 && vibStrength >= 3 && aroused.GetActorExposure(akActor)>= 99
			int cumChance = (vibStrength * 2 * combatModifier) as Int
			Log("CumChance:"+cumChance+", vibStrength:"+vibStrength)
			if Utility.RandomInt() <= cumChance
				;;;;;;;;;;
				; Kill previous animation, if any.
				;;;;;;;;;;
				if vibAnimStarted != 0
					EndThirdPersonAnimation(akActor, cameraState, permitRestrictive=true)
					vibAnimStarted = 0
				EndIf
				actorCame += 1
				if teaseOnly
					ApplyExpressionRaw(akActor, GetPrebuildExpression_Orgasm1(),65, 100, openMouth=false)
					Sound.StopInstance(vsID)
					Sound.StopInstance(msID)
					StopVibrating(akActor)
					if !silent && akActor == PlayerRef
						NotifyPlayer("The vibrations abruptly stop just short of bringing you to orgasm.")
					Endif
					EdgeActor(akActor)
					ResetExpressionRaw(akActor, 65)
					SendModEvent("DeviceVibrateEffectStop", akActor.GetLeveledActorBase().GetName(), vibStrength * numVibratorsMult)
					return -1
				EndIf
				ApplyExpressionRaw(akActor, GetPrebuildExpression_Orgasm2(),65, 100, openMouth=false)
				if !silent && akActor == PlayerRef
					NotifyPlayer("The plugs bring you to a thunderous climax.")
				EndIf
				Sound.StopInstance(msID)
				ActorOrgasm(akActor, vsID=vsID)
				ResetExpressionRaw(akActor, 65)
				if IsVibrating(akActor)
					msID = MoanSound.Play(akActor)
					Sound.SetInstanceVolume(msID, GetMoanVolume(akActor))
				EndIf
			EndIf
		EndIf
		; Log("XXX VibrateEffect: Done Let the actor cum?")
		;;;;;;;;;;
		; Increase arousal, moan sound.
		;;;;;;;;;;
		if (timeVibrated % (6-vibStrength)) == 0
			; Log("XXX VibrateEffect: Increasing Arousal")
			UpdateExposure(akActor, 5 * combatModifier * numVibratorsMult, skipMultiplier=true)
			; Log("XXX VibrateEffect: Arousal 2")
			Sound.SetInstanceVolume(msID, GetMoanVolume(akActor))
			; Log("XXX VibrateEffect: Done Increasing Arousal")
		EndIf
		;;;;;;;;;;
		; Play horny idle?
		;;;;;;;;;;
		if (vibAnimStarted == 0) && Utility.RandomInt() <= (3+(VibStrength * 2)) && !IsAnimating(akActor)
			; Log("XXX Starting Horny Idle")
			ApplyExpression(akActor, expression, (Aroused.GetActorExposure(akActor) * 0.75) as Int, openMouth=true)
			; Select animation
      if !EnableVRSupport
			  cameraState=StartThirdPersonAnimation(akActor, AnimSwitchKeyword(akActor, "Horny"), permitRestrictive=true)
      EndIf
			vibAnimStarted = timeVibrated + 1
			; Log("XXX VibrateEffect: Done starting horny idle")
		EndIf
		;;;;;;;;;;
		; Stop horny idle?
		;;;;;;;;;;
		if (vibAnimStarted != 0) && (timeVibrated - vibAnimStarted >= 6) ; Stop animation after 5 seconds.
			; Log("XXX Stopping Horny Idle")
			ApplyExpression_v2(akActor, expression,15, (timeVibrated / duration) * 75, openMouth=False)
			EndThirdPersonAnimation(akActor, cameraState, permitRestrictive=true)
			vibAnimStarted = 0
			; Log("XXX VibrateEffect: Done stopping horny idle")
		EndIf
		;;;;;;;;;;
		; Shake camera effect.
		;;;;;;;;;
		if akActor == PlayerRef
			; Log("XXX VibrateEffect: Shaking Camera")
			;Game.ShakeCamera(akActor, (0.05*vibStrength), 1)
			; Log("XXX VibrateEffect: Done Shaking Camera")
		EndIf
		; Log("XXX VibrateEffect: End Tick "+timeVibrated+".")
		Utility.Wait(1)
		timeVibrated += 1
	EndWhile

	Sound.StopInstance(vsID)
	Sound.StopInstance(msID)
	if IsValidActorV2(akActor, AllowActorInScene)
		; Reset expression
		ResetExpressionRaw(akActor, 15)
	EndIf
	;;;;;;;;;;
	; Make sure actor isn't stuck in animation
	;;;;;;;;;;
	if  vibAnimStarted != 0
		EndThirdPersonAnimation(akActor, cameraState, permitRestrictive=true)
		vibAnimStarted = 0
	EndIf
	StopVibrating(akActor)
	if !silent && akActor == PlayerRef
		NotifyPlayer(BuildPostVibrationString(akActor, vibStrength, vPlug, aPlug, vPiercings, nPiercings))
	Endif
	SendModEvent("DeviceVibrateEffectStop", akActor.GetLeveledActorBase().GetName(), vibStrength * numVibratorsMult)
	UpdateArousalTimeRate(akActor, vibStrength * numVibratorsMult)
	Aroused.GetActorArousal(akActor)
	return actorCame
EndFunction


Function AttrDrain(actor akActor, string attr)
	float randomize = (Utility.RandomInt(1,75) as Float) / 100
	int drain = (akActor.GetAv(attr) * randomize) as Int
	Log(attr+"DrainEffect(): Draining "+drain + "("+randomize+" %)")
	akActor.DamageAv(attr, drain)
EndFunction


Function HealthDrainEffect(actor akActor)
	AttrDrain(akActor, "Health")
EndFunction


Function ManaDrainEffect(actor akActor)
	AttrDrain(akActor, "Magicka")
EndFunction


Function StaminaDrainEffect(actor akActor)
	AttrDrain(akActor, "Stamina")
EndFunction


Bool Function ShouldEdgeActor(actor akActor)
	if ActorHasKeyword(akActor, zad_EffectEdgeOnly)
		return true
	ElseIf ActorHasKeyword(akActor, zad_EffectEdgeRandom) && Utility.RandomInt() >= 25
		return true
	EndIf
	return false
EndFunction

Bool Function ActorHasKeyword(actor akActor, keyword kwd)
	return (akActor.HasMagicEffectWithKeyword(kwd) || akActor.WornHasKeyword(kwd))
EndFunction

Function ApplyMagickaPenalty(actor akActor)
	zad_splMagickaPenalty.RemoteCast(akActor, akActor, akActor)
	float currentMag = akActor.GetActorValue("Magicka")
	akActor.DamageActorValue("Magicka", currentMag * 0.25)	
EndFunction
	
Function SpellCastVibrate(Actor akActor, Form tmp)
	Spell theSpell = (tmp as Spell)
	if akActor.WornHasKeyword(zad_DeviousPlug) && ActorHasKeyword(akActor, zad_EffectVibrateOnSpellCast)
		SendModEvent("EventOnCast")
		Log("OnSpellCast()")
		If akActor == PlayerRef && akActor.GetCombatState() >= 1
			; punish her only every so often
			if (Utility.GetCurrentRealTime() > SpellCastVibrateCooldown)					
				SpellCastVibrateCooldown = Utility.GetCurrentRealTime() + 60 ; 60 seconds cooldown
			else
				return
			endif		
			Log("Player is in combat while trying to cast spell: Applying magicka penalty.")
			; Hit Magicka and Mag Rate
			ApplyMagickaPenalty(akActor)
			return			
		Endif
		Shout isShout = (tmp as Shout)
		; Log("isShout: "+isShout)
		int cost = theSpell.GetEffectiveMagickaCost(akActor)
		if cost <= 1 && !isShout
			return
		EndIf
		int duration = (cost * 0.1) as Int
		int vibStrength = (cost / 50) as Int
		if isShout != none || cost > 500 ;akActor.GetActorValuePercentage("Magicka") ; This would just reintroduce the problem for high-end mages...
			; akSpell as Shout (And WordOfPower) is none for whirlwind sprint, and cost is 500ish. Wtf. Hack workaround.
			Log("Spell is in fact a shout.")
			vibStrength = 2
			duration = 5
		EndIf
		if ActorHasKeyword(akActor, zad_EffectTrainOnSpellCast)
			TrainingViolation(akActor, "SpellCast");
			if vibStrength <= 1
				vibStrength = 3
			Else
				vibStrength *= 2
			EndIf
			duration /= 2
		EndIf
		if vibStrength > 5
			vibStrength = 5
		EndIf
		if vibStrength < 1
			vibStrength = 1
		EndIf
		if duration <= 0
			duration = 1
		EndIf
		;NotifyPlayer("The plugs respond to the magicka flowing through you, and begin to vibrate!")
		if Utility.RandomInt() <= vibStrength * 15
			;Log("Interrupting cast.")
			; PlayerRef.InterruptCast()
			; NotifyPlayer("Your concentration wanes, and the spell fizzles.")
		EndIf
		VibrateEffect(akActor, vibStrength, duration, teaseOnly=ShouldEdgeActor(akActor))
	EndIf
EndFunction

;Parameters are persitant in pex files. 2-stage function call to avoid breaking older mods.
; This is the old signature of the function, and is needed for backwards compatibility
Bool Function IsValidActor(Actor akActor)
    return IsValidActorV2(akActor, OverrideSceneCheck = false)
EndFunction

; This one allows more fine-tuned control by allowing callers to consider actors in scenes as valid
Bool Function IsValidActorV2(Actor akActor, bool OverrideSceneCheck = false)
	If !akActor.Is3DLoaded() || akActor.IsChild() || akActor.IsDisabled() || akActor.IsDead()
		return False
	EndIf 	
	if akActor.GetCurrentScene() != none && OverrideSceneCheck == false
		return False
	EndIf
	return True
EndFunction

Function DisableControls()	
	Game.DisablePlayerControls(abMovement = True, abFighting = True, abSneaking = False, abMenu = True, abActivate = True)
EndFunction

Function UpdateControls()
	log("UpdateControls()")
	SendDDFunctionEvent ("UpdateControls", playerRef)	
	; Centralized control management function.
	bool movement = true
	bool fighting = true
	bool sneaking = true
	bool menu = true
	bool activate = true
	int cameraState = Game.GetCameraState()
	if playerRef.WornHasKeyword(zad_DeviousBlindfold) && (config.BlindfoldMode == 1 || config.BlindfoldMode == 0) && (cameraState == 8 || cameraState == 9)
		movement = false
		sneaking = false
	EndIf
	if IsBound(playerRef)
		If playerRef.WornHasKeyword(zad_BoundCombatDisableKick)
			fighting = false			
		Else
			fighting = config.UseBoundCombat			
		Endif	
	EndIf
	if playerRef.WornHasKeyword(zad_DeviousPetSuit)
		sneaking = false
	EndIf	
	if playerRef.WornHasKeyword(zad_DeviousPonyGear)
		sneaking = false
	EndIf	
	Game.DisablePlayerControls(abMovement = !movement, abFighting = !fighting, abSneaking = !sneaking, abMenu = !menu, abActivate = !activate)	
	Game.EnablePlayerControls(abMovement = movement, abFighting = fighting, abSneaking = sneaking, abMenu = menu, abActivate = activate)	
EndFunction

;==================================================
; Mutex Functions
;==================================================
; Is the actor animating through Sexlab, or DD?
bool Function IsAnimating(actor akActor)
	if (akActor.GetSitState() != 0) || akActor.IsOnMount()
		return True
	endif
	return (akActor.IsInFaction(zadAnimatingFaction) || akActor.IsInFaction(Sexlab.AnimatingFaction))
EndFunction

; Set DD's actor animating status.
Function SetAnimating(actor akActor, bool isAnimating=true)
	if isAnimating
		akActor.AddToFaction(zadAnimatingFaction)
		akActor.SetFactionRank(zadAnimatingFaction, 1)
	Else
		akActor.RemoveFromFaction(zadAnimatingFaction)
	EndIf
EndFunction

; Is the actor currently in a vibration event?
bool Function IsVibrating(actor akActor)
	return akActor.IsInFaction(zadVibratorFaction)
EndFunction

Function SetVibrating(actor akActor, int duration)
	bool oor = false
	if (duration < 0)
		oor = true
		duration = 1
	ElseIf (duration >= 127)
		oor = true
		duration = 126
	EndIf
	if oor
		Warn("SetVibrating(" + duration + ") received out of range value")
	EndIf
	; akActor.AddToFaction(zadVibratorFaction)
	akActor.SetFactionRank(zadVibratorFaction, duration)
EndFunction

; Stop vibration event on actor.
Function StopVibrating(actor akActor)
	akActor.SetFactionRank(zadVibratorFaction, 0)
	akActor.RemoveFromFaction(zadVibratorFaction)
EndFunction

; Get duration left on current vibration event for actor.
int Function GetVibrating(actor akActor)
	if !akActor.IsInFaction(zadVibratorFaction)
		return 0
	EndIf
	return akActor.GetFactionRank(zadVibratorFaction)
EndFunction

Function ApplyGagEffect(actor akActor)
    ExpLibs.ApplyGagEffect(akActor)
EndFunction

Function RemoveGagEffect(actor akActor)
    ExpLibs.RemoveGagEffect(akActor)
EndFunction

Function SendGagEffectEvent(actor akActor, bool isRemove)
    Int Handle = ModEvent.Create("DDI_GagExpressionStateChange")
    If (Handle)    
        ModEvent.PushForm(Handle, akActor)
        ModEvent.PushBool(Handle, isRemove)
        ModEvent.Send(Handle)
    Endif  
EndFunction

string Function MakeSingularIfPlural(string theString)
	int len = getLength(theString)
	if GetNthChar(theString, (len - 1)) == "s"
		return Substring(theString, 0, len - 1)
	EndIf
	return theString
EndFunction

;This function picks animations based on provided context and worn devices
String Function AnimSwitchKeyword( actor akActor, string idleName )
	
;THERE USED TO BE SOMETHING BIG HERE, AND NOW OAR HANDLES THIS - krzp
	If idleName == "Horny" || idleName == "Horny01" || idleName == "Horny02" || idleName == "Horny03"
			return "DDZazHornyA"
	ElseIf idleName == "Edged"
			return "DDZazHornyD"
	ElseIf idleName == "Orgasm"
			return "DDZazHornyE"
	ElseIf idleName == "OutOfBreath"
		return "ft_out_of_breath_reg"
	EndIf	
	Error("Failed to find valid animation for presentation.")
EndFunction

Function RepopulateNpcs()
	if repopulateMutex ; Avoid this getting hit too quickly while comparing times.
		Log("RepopulateNpcs() is already processing.")
		return
	EndIf
	repopulateMutex=true
	Log("RepopulateNpcs()")
	if Utility.GetCurrentRealTime() - lastRepopulateTime <= 5
		Log("Aborting repopulation of NPC slots: Hit throttle.")
		repopulateMutex=false
		return
	EndIf
	lastRepopulateTime = Utility.GetCurrentRealTime()
	if zadNPCQuest.IsProcessing
		Log("Waiting, since NPC Events is currently processing.")
		int timeout = 0
		while zadNPCQuest.IsProcessing && timeout <= 24
			Utility.Wait(5)
			timeout += 1
		EndWhile
		if timeout >= 24
			Warn("RepopulateNpcs() spinlock timed out!!")
			zadNPCQuest.IsProcessing = false
		EndIf
	EndIf
	if !zadNPCSlots.IsStopping() && !zadNPCSlots.IsStarting()
		if zadNPCSlots.IsRunning()
			zadNPCSlots.Stop()
		EndIf
		If config.NumNpcs>0
			; Feels like a race condition / timing issue?
			; Perhaps if I call a short wait (Thus suspending execution, giving the quest a chance to fully stop?), it won't occur.
			Utility.Wait(2.0)
			zadNPCSlots.Start()
		Else
			Log("Not repopulating NPC slots: Feature is disabled.")
		EndIf
	Else
		Warn("Not repopulating NPC slots: Quest is changing state.")
	EndIf
	repopulateMutex=false
EndFunction

Function PlugPanelGag(actor akActor)
	if akActor.GetFactionRank(zadGagPanelFaction) <= -1
		Error("PlugPanelGag called on actor that is not wearing a panel gag.")
		return
	EndIf
	SendModEvent("GagPanelStateChange", akActor.GetLeveledActorBase().GetName(), 1.0)
	akActor.RemoveItem(zad_gagPanelPlug, 1)
	akActor.SetFactionRank(zadGagPanelFaction, 1)
EndFunction

Function UnPlugPanelGag(actor akActor)
	if akActor.GetFactionRank(zadGagPanelFaction) <= -1
		Error("UnPlugPanelGag called on actor that is not wearing a panel gag.")
		return
	EndIf
	SendModEvent("GagPanelStateChange", akActor.GetLeveledActorBase().GetName(), 0.0)
	akActor.AddItem(zad_gagPanelPlug, 1)
	akActor.SetFactionRank(zadGagPanelFaction, 0)
EndFunction


bool Function IsBound(actor akActor)
	return akActor.WornHasKeyword(zad_DeviousHeavyBondage) || (akActor.WornHasKeyword(zad_DeviousArmbinder) || akActor.WornHasKeyword(zad_DeviousArmBinderElbow) || akActor.WornHasKeyword(zad_DeviousYoke) || akActor.WornHasKeyword(zad_DeviousYokeBB) || akActor.WornHasKeyword(zad_DeviousStraitJacket))
EndFunction

bool Function NeedsBoundAnim(actor akActor)
	return akActor.WornHasKeyword(zad_DeviousCuffsFront) || akActor.WornHasKeyword(zad_DeviousElbowTie) || (akActor.WornHasKeyword(zad_DeviousArmbinder) || akActor.WornHasKeyword(zad_DeviousArmBinderElbow) || akActor.WornHasKeyword(zad_DeviousYoke) || akActor.WornHasKeyword(zad_DeviousYokeBB) || akActor.WornHasKeyword(zad_DeviousPetSuit))
EndFunction

Function ToggleCompass(bool show)
	float alpha = 0.0
	if show
		alpha = 100.0
	EndIf
	; Log("ToggleCompass: "+UI.GetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder._alpha"))
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder._alpha", alpha)
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder.Compass.DirectionRect._alpha", alpha)
	UI.SetNumber("HUD Menu", "_root.HUDMovieBaseInstance.CompassShoutMeterHolder.Compass.CompassFrame._alpha", alpha)
EndFunction

Function TrainingViolation(actor akActor, string violation)
	if akActor == playerRef
		log("TrainingViolation(player, "+violation+")")
		SendModEvent("TrainingViolation", violation, 0.0)
	EndIf
EndFunction


Function ShockActor(actor akActor)
	if akActor == playerRef
		NotifyPlayer("The plugs within you let out a powerful electrical shock!")
		log("zadLibs: ShockActor")
	Else
		NotifyNPC(akActor.GetLeveledActorBase().GetName()+" squirms uncomfortably as electricity runs through her.")
	EndIf
	ShockEffect.RemoteCast(akActor, akActor, akActor)
	Aroused.SetActorExposure(akActor, Utility.RandomInt(10,20))
EndFunction


Form Function GetRenderedDeviceInstance(actor akActor, int Slot, Keyword kwd)
	form f1 = akActor.GetWornForm(Slot) 
	if f1 && f1.HasKeyword(kwd)
		return f1
	Endif
	return none
EndFunction

Form Function GetWornHeavyBondageInstance(actor akActor)
	; akActor.GetWornForm(0x20000000)
	; 0x00010000 is slot 46, the new "Heavy Bondage" slot.
	form armb = GetRenderedDeviceInstance(akActor, 0x00010000, zad_DeviousArmbinder)
	if !armb ; Check for yokes
		armb = GetRenderedDeviceInstance(akActor, 0x00010000, zad_DeviousYoke)
	EndIf
	if !armb ; Check for straitjackets
		armb = GetRenderedDeviceInstance(akActor, 0x00010000, zad_DeviousStraitJacket)
	EndIf
	if !armb ; Check for elbowbinders
		armb = GetRenderedDeviceInstance(akActor, 0x00010000, zad_DeviousArmbinderElbow)
	EndIf
	if !armb ; Check for breastyokes
		armb = GetRenderedDeviceInstance(akActor, 0x00010000, zad_DeviousYokeBB)
	EndIf
	if !armb ; Check for frontcuffs
		armb = GetRenderedDeviceInstance(akActor, 0x00010000, zad_DeviousCuffsFront)
	EndIf
	if !armb ; Check for elbowshackles
		armb = GetRenderedDeviceInstance(akActor, 0x00010000, zad_DeviousElbowTie)
	EndIf
	return armb
EndFunction


Function UpdateArousalTimerate(actor akActor, float val)
	if Aroused.GetActorTimerate(akActor) <= 50.0
		Aroused.UpdateActorTimeRate(akActor, val)
	EndIf
EndFunction

Function ChastityBeltStruggle(actor akActor)
	; sanity check
	If !akActor.WornHasKeyword(zad_DeviousBelt) || akActor.WornHasKeyword(zad_DeviousHeavyBondage) || BoundCombat.HasCompatibleDevice(akActor)
		Return
	EndIf
	; this should delay any anims if there is a menu open
	Utility.Wait(0.1)
	; don't play anims if the actor is already in one.
	If IsAnimating(akActor)
		return
	EndIf	
	; don't play the animation in combat if it's the player
	if akActor == playerref && playerref.IsInCombat() 
		return 
	Endif
	; use PlayThirdPersonAnimation instead of StartThirdPersonAnimation for non-looping animation
	; alternatively EndThirdPersonAnimation can be called manually if termination is conditional
  if EnableVRSupport
    PlayThirdPersonAnimation(akActor, "DDChastityBeltStruggle0" + Utility.RandomInt(1, 2), Utility.RandomInt(3, 4), true)
  else
    PlayThirdPersonAnimation(akActor, "DDChastityBeltStruggle0" + Utility.RandomInt(1, 2), Utility.RandomInt(5, 30), true)
  endif
	Aroused.UpdateActorExposure(akActor, 5)
	If akActor == PlayerRef
		notify("You tug at your chastity belt, but it won't come off!")
	EndIf
	SexlabMoan(akActor)		
	If aroused.GetActorExposure(akActor) > 75
		PlayHornyAnimation(akActor)	
		If akActor == PlayerRef
			notify("You are incredibly horny and try to force a finger inside your belt.")
		EndIf
	EndIf
EndFunction

Function Trip(actor akActor)
	; this should delay any anims if there is a menu open
	Utility.Wait(0.1)
	; don't play anims if the actor is already in one.
	If IsAnimating(akActor)
		return
	EndIf	
	; don't play the animation in combat if it's the player
	if akActor == playerref && playerref.IsInCombat() 
		return 
	Endif
	; use PlayThirdPersonAnimation instead of StartThirdPersonAnimation for non-looping animation
	; alternatively EndThirdPersonAnimation can be called manually if termination is conditional
	
	; OAR NOW REPLACES ANIMATIONS BASED ON KEYWORDS - krzp
  if EnableVRSupport
  	PlayThirdPersonAnimation(akActor, "ft_fall_over_reg_1", 2, true)
  else
    PlayThirdPersonAnimation(akActor, "ft_fall_over_reg_1", 8, true)
  EndIf
		
	SexlabMoan(akActor)
EndFunction

Function CatchBreath(actor akActor)
	; this should delay any anims if there is a menu open
	Utility.Wait(0.1)
	; don't play anims if the actor is already in one.
	If IsAnimating(akActor)
		return
	EndIf	
	; don't play the animation in combat if it's the player
	if akActor == playerref && playerref.IsInCombat() 
		return 
	Endif
	; use PlayThirdPersonAnimation instead of StartThirdPersonAnimation for non-looping animation
	; alternatively EndThirdPersonAnimation can be called manually if termination is conditional
	
	; OAR NOW REPLACES THEM BASED ON KEYWORDS - krzp
  if EnableVRSupport
		PlayThirdPersonAnimation(akActor, "ft_out_of_breath_reg", 2, true)
  else
    PlayThirdPersonAnimation(akActor, "ft_out_of_breath_reg", 5, true)
  EndIf
	
	SexlabMoan(akActor)
EndFunction

; theIdle is a remnant of long-depreciated ZAP offsets
; putting stuff there no longer does anything, it's kept for backwards-compatibility but should be removed eventually
Function ApplyBoundAnim(actor akActor, idle theIdle = None)
	Log("ApplyBoundAnim()")
	if akActor.GetEquippedWeapon()
		akActor.UnequipItem(akActor.GetEquippedWeapon(), false, true)
	EndIf
	if akActor.GetEquippedWeapon(True)
		akActor.UnequipItem(akActor.GetEquippedWeapon(true), false, true)
	EndIf
	If akActor.GetEquippedShield()
		akActor.UnequipItem(akActor.GetEquippedShield(), false, true)
	EndIf
	if akActor.GetEquippedSpell(0)
		akActor.UnequipSpell(akActor.GetEquippedSpell(0), 0)
	EndIf
	if akActor.GetEquippedSpell(1)
		akActor.UnequipSpell(akActor.GetEquippedSpell(1), 1)
	EndIf
	if akActor.IsWeaponDrawn()
		if config.UseBoundCombat
			return
		EndIf
		akActor.SheatheWeapon()
	EndIf
	if akActor.IsOnMount()
		akActor.Dismount()
	EndIf
EndFunction

; Turns off dialogue processing. Note that Pausing uses a reference counting
; system, so each pause must be matched with exactly one Resume.
; 
Function PauseDialogue()
	DialogueGagDisable.Mod(1)
	DialogueArmbinderDisable.Mod(1)
EndFunction

; Resumes dialogue processing. Note that Pausing uses a reference counting
; system, so each resume must be in response to exactly one pause. Dialogue 
; processing is not resumed until all pauses have been countered.
; 
Function ResumeDialogue()
	DialogueGagDisable.Mod(-1)
	DialogueArmbinderDisable.Mod(-1)
EndFunction

; Forces resume of dialogue pausing
; 
; Do not call this function directly. It's intended to be used at game load to 
; prevent dialogue from becoming stuck.
; 
Function ResetDialogue()
	DialogueGagDisable.SetValueInt(0)
	DialogueArmbinderDisable.SetValueInt(0)
EndFunction

; Adds the actor to the faction that disables the built in gag
; and armbinder dialogue.
; 
Function AddToDisableDialogueFaction(Actor akActor)
	akActor.AddToFaction(zadDisableDialogueFaction)
EndFunction

; Removes the actor from the faction that disables the built in gag
; and armbinder dialogue.
; 
Function RemoveFromDisableDialogueFaction(Actor akActor)
	akActor.RemoveFromFaction(zadDisableDialogueFaction)
EndFunction


Function HideBreasts(actor akActor)
	if config.BreastNodeManagement
		bool gender = akActor.GetLeveledActorBase().GetSex() == 1
		SetNodeHidden(akActor, gender, "NPC L Breast", true)
		SetNodeHidden(akActor, gender, "NPC R Breast", true)
		If (NetImmerse.HasNode(akActor, "3BA", false) || NetImmerse.HasNode(akActor, "3BBB", false))
			SetNodeHidden(akActor, gender, "L Breast01", true)
			SetNodeHidden(akActor, gender, "L Breast02", true)
			SetNodeHidden(akActor, gender, "L Breast03", true)
			SetNodeHidden(akActor, gender, "R Breast01", true)
			SetNodeHidden(akActor, gender, "R Breast02", true)
			SetNodeHidden(akActor, gender, "R Breast03", true)
		endif
	EndIf
EndFunction


Function ShowBreasts(actor akActor)
	; Shown regardless of BreastNodeManagement enabled or not
	; Visually doesn't change anything on unhide if option is disabled
	; But user cant keep the nodes hidden by enabling the option equipping a bra
	; Disabling the option and unequipping the bra
	bool gender = akActor.GetLeveledActorBase().GetSex() == 1
	SetNodeHidden(akActor, gender, "NPC L Breast", false)
	SetNodeHidden(akActor, gender, "NPC R Breast", false)
	If (NetImmerse.HasNode(akActor, "3BA", false) || NetImmerse.HasNode(akActor, "3BBB", false))
		SetNodeHidden(akActor, gender, "L Breast01", false)
		SetNodeHidden(akActor, gender, "L Breast02", false)
		SetNodeHidden(akActor, gender, "L Breast03", false)
		SetNodeHidden(akActor, gender, "R Breast01", false)
		SetNodeHidden(akActor, gender, "R Breast02", false)
		SetNodeHidden(akActor, gender, "R Breast03", false)
	endif
EndFunction


Function HideBelly(actor akActor)
	if config.BellyNodeManagement
		bool gender = akActor.GetLeveledActorBase().GetSex() == 1
		SetNodeHidden(akActor, gender, "NPC Belly", true)
	EndIf
EndFunction


Function ShowBelly(actor akActor)
	; See ShowBreasts()
	bool gender = akActor.GetLeveledActorBase().GetSex() == 1
	SetNodeHidden(akActor, gender, "NPC Belly", false)
EndFunction

Function SetNodeHidden(Actor akActor, bool isFemale, string nodeName, bool value, string modkey = "DDi")
if Config.GotSLIF
		if value
			SLIF_Main.hideNode(akActor, "Devious Devices Integration", nodeName, 0.01, modkey)
		else
			SLIF_Main.showNode(akActor, "Devious Devices Integration", nodeName)
		endif
	else
	if value
		XPMSELib.SetNodeScale(akActor, isFemale, nodeName, 0.01, modkey)
	else
		XPMSELib.SetNodeScale(akActor, isFemale, nodeName, 1.0, modkey)
	endif
endif
EndFunction

string Function LookupDeviceType(keyword kwd)
	if kwd == zad_DeviousPlug
		return "Plug"
	ElseIf kwd == zad_DeviousHeavyBondage
		return "WristRestraint"
	ElseIf kwd == zad_DeviousBelt
		return "Belt" 
	ElseIf kwd == zad_DeviousBra
		return "Bra"  
	ElseIf kwd == zad_DeviousCollar
		return "Collar"  
	ElseIf kwd == zad_DeviousArmCuffs
		return "ArmCuffs"  
	ElseIf kwd == zad_DeviousLegCuffs
		return "LegCuffs"  
	ElseIf kwd == zad_DeviousArmbinder
		return "Armbinder"  
	ElseIf kwd == zad_DeviousYoke
		return "Yoke"  
	ElseIf kwd == zad_DeviousCorset
		return "Corset"  
	ElseIf kwd == zad_DeviousClamps
		return "Clamps"  
	ElseIf kwd == zad_DeviousGloves
		return "Gloves"  
	ElseIf kwd == zad_DeviousHood
		return "Hood"  
	ElseIf kwd == zad_DeviousSuit
		return "Suit"  
	ElseIf kwd == zad_DeviousGag
		return "Gag"  
	ElseIf kwd == zad_DeviousGagPanel
		return "GagPanel"  
	ElseIf kwd == zad_DeviousPlugVaginal
		return "PlugVaginal"  
	ElseIf kwd == zad_DeviousPlugAnal
		return "PlugAnal"  
	ElseIf kwd == zad_DeviousHarness
		return "Harness"  
	ElseIf kwd == zad_DeviousBlindfold
		return "Blindfold"  
	ElseIf kwd == zad_DeviousBoots
		return "Boots"  
	ElseIf kwd == zad_DeviousPiercingsNipple
		return "PiercingsNipple"  
	ElseIf kwd == zad_DeviousPiercingsVaginal
		return "PiercingsVaginal"
	ElseIf kwd == zad_DeviousArmbinderElbow
		return "ArmBinderElbow"
	ElseIf kwd == zad_DeviousYokeBB
		return "YokeBB"
	ElseIf kwd == zad_DeviousCuffsFront
		return "CuffsFront"
	ElseIf kwd == zad_DeviousStraitJacket
		return "StraitJacket"
	ElseIf kwd == zad_DeviousBondageMittens
		return "Mittens"
	ElseIf kwd == zad_DeviousHobbleSkirt
		return "HobbleSkirt"	
	ElseIf kwd == zad_DeviousHobbleSkirtRelaxed
		return "HobbleSkirt"
	EndIf
	Log("LookupDeviceType received invalid keyword " + kwd)
EndFunction

function strip(actor a, bool animate = false)
    Spell spl
    Weapon weap
    Armor sh
    Ammo amm
    Form frm
    stripweapons(a)
    frm = a.GetWornForm(0x00001000) ; circlet
    if frm && !frm.HasKeyWordString("SexLabNoStrip")
        a.unequipItem(frm, abSilent = true)
    endif
    frm = a.GetWornForm(0x00000020) ; amulet
    if frm && !frm.HasKeyWordString("SexLabNoStrip")
        a.unequipItem(frm, abSilent = true)
    endif
    If a.WornHasKeyWord(zad_DeviousHeavyBondage)
        animate = false
    EndIf
    SexLab.StripActor(a, doanimate = animate, leadIn = false) 	
EndFunction

bool function hasAnyWeaponEquipped(actor a)
    if !a.GetEquippedObject(0) && !a.GetEquippedObject(1)
        return false
    endif
    return true
EndFunction

function stripweapons(actor a, bool unequiponly = true)
    int i = 10
    
    Form loc_lefthand   = none
    Form loc_righthand  = none
    
    While i > 0
        i -= 1
        loc_lefthand = a.GetEquippedObject(0)
        if loc_lefthand
            a.unequipItem(loc_lefthand, false, true)
        endif
        if loc_lefthand as Spell
            a.UnequipSpell(loc_lefthand as Spell,0)
        endif
        
        loc_righthand = a.GetEquippedObject(1)
        if loc_righthand
            a.unequipItem(loc_righthand, false, true)
        endif
        if loc_righthand as Spell
            a.UnequipSpell(loc_righthand as Spell,1)
        endif
        if loc_lefthand || loc_righthand || a.IsWeaponDrawn()
            a.SheatheWeapon()
            Utility.Wait(0.1)
        else
            return
        endif
    EndWhile
endfunction

Event StartBoundEffects(Actor akTarget)
	if !akTarget.WornHasKeyword(zad_DeviousHeavyBondage) && !akTarget.WornHasKeyword(zad_DeviousHobbleSkirt) && !akTarget.WornHasKeyword(zad_DeviousPonyGear)
		return
	EndIf
	stripweapons(akTarget)
	if akTarget != PlayerRef
		BoundCombat.EvaluateAA(akTarget)
		;BoundCombat.Apply_NPC_ABC(akTarget)
		return
	EndIf
	Log("OnEffectStart(): Bound Effects")
	PlayBoundIdle()
	RegisterForSingleUpdate(8.0)
	if aktarget == PlayerRef
		UpdateControls()
	Endif
EndEvent

Event StopBoundEffects(Actor akTarget)
	Log("OnEffectFinish(): Bound Effects")
	;COMMENTED THAT OUT BECAUSE IdleForceDefaultState IS NOW SENT IN EVALUATE AA 	
	;Debug.SendAnimationEvent(akTarget, "IdleForceDefaultState")	
	if aktarget == PlayerRef
		UnregisterForUpdate()
		UpdateControls()
	EndIf	
	BoundCombat.EvaluateAA(akTarget)
EndEvent

Event OnUpdate()
	If Config.debugSigTerm
		Config.debugSigTerm = false
		DDI_DebugTerminate()
		; let's delay the next update, to make sure the debug has ample time to complete
		RegisterForSingleUpdate(20.0)
		Return
	EndIf
	If Config.debugFixDevices
		Config.debugFixDevices = false
		DDI_DebugFixDevices()
		; let's delay the next update, to make sure the debug has ample time to complete
		RegisterForSingleUpdate(20.0)
		Return
	EndIf
	If Config.RegisterDevices
		Config.RegisterDevices = false
		SendModEvent("DDI_RegisterDevices")
		; let's delay the next update, to make sure the command has ample time to complete
		RegisterForSingleUpdate(20.0)
		Return
	EndIf
	if  (Game.IsMenuControlsEnabled() || Game.IsFightingControlsEnabled())
		if !IsAnimating(PlayerRef)
			UpdateControls()
		EndIf
	EndIf
	RegisterForSingleUpdate(8.0)
EndEvent

Function PlayBoundIdle()
	BoundCombat.EvaluateAA(PlayerRef)
	if !IsAnimating(PlayerRef) && !PlayerRef.IsInFaction(SexLabAnimatingFaction) 
		ApplyBoundAnim(PlayerRef)
	EndIf
EndFunction

Bool Function UseRubberSounds()
	Return (Config.RubberSoundMode > 0)
EndFunction

Float Function GetRubberSoundOffset()
	Float offset = 0.0
	If Config.RubberSoundMode == 1
		offset = 30.0
	elseif Config.RubberSoundMode == 2
		offset = 10.0
	elseif Config.RubberSoundMode == 3
		offset = 0.0
	EndIf
	return offset
EndFunction

Function UnsetStoredDevice(actor akActor, keyword zad_DeviousDevice)
	StorageUtil.UnsetFormValue(akActor, "zad_Equipped" + LookupDeviceType(zad_DeviousDevice) + "_Inventory")
	StorageUtil.UnsetFormValue(akActor, "zad_Equipped" + LookupDeviceType(zad_DeviousDevice) + "_Rendered")
	StorageUtil.UnsetFormValue(akActor, "zad_Equipped" + LookupDeviceType(zad_DeviousDevice) + "_Key")	
EndFunction

Function RestoreSettings(actor akActor)
	float originalExposureRate = GetOriginalRate(akActor)
    Log("Restoring original exposure rate to " + originalExposureRate)
    Aroused.SetActorExposureRate(akActor, originalExposureRate)
	StorageUtil.UnSetFloatValue(akActor, "zad.StoredExposureRate")
EndFunction

;===============================================================================
; GameSettings Manipulation
;===============================================================================
; These need to be refreshed OnPlayerLoadGame (zadPlayerScript)
; Otherwise they revert to their default state.

Function MuteOverEncumberedMSG()
	Game.SetGameSettingString("sOverEncumbered", "")
	Game.SetGameSettingString("sNoFastTravelOverencumbered", "You cannot fast travel in these restraints.")
EndFunction


;===============================================================================
; Everything below is DEPRECATED STUFF - Do NOT use. Will be removed in a future version!!!
;===============================================================================

; Deprecated, do NOT use - left in the code to make 5.0 backwards compatible with older versions. Use LockDevice() instead.
; Due to its wide-spread use, this function and its counterpart RemoveDevice() are likely not to be removed from the API, but if you want to spare your mod the redundant function-call, 
; it's recommended to replace this function in your code anyway. skipEvents and skipMutex are of course ignored since 5.0.
Function EquipDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool skipEvents=false, bool skipMutex=false)			
	LockDevice(akActor, deviceInventory)
EndFunction

; Deprecated, do NOT use - left in the code to make 5.0 backwards compatible with older versions. Use UnlockDevice() instead.
Function RemoveDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool destroyDevice=false, bool skipEvents=false, bool skipMutex=false)	
	UnlockDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, destroyDevice)
EndFunction

; As manipulate device, but will operate on any device lacking the zad_BlockGeneric keyword: Even those who's rendered device / keyword you don't know.
; Returns true if a device was successfully manipulated.
; Deprecated: Use either LockDevice() or UnlockDevice() with genericonly = true
bool Function ManipulateGenericDevice(actor akActor, armor device, bool equipOrUnequip, bool skipEvents = false , bool skipMutex = false)
	bool manipulated = false
	Keyword kw = GetDeviceKeyword(device)
    Armor loc_rd = GetRenderDevice(device)
	if loc_rd.HasKeyword(zad_BlockGeneric) || loc_rd.HasKeyword(zad_QuestItem)
		Warn("ManipulateGenericDevice called on non-generic device.")
	Else
		; First, check to see if the actor is already wearing this device. If he is, save processing time.
		Form tmpInv = StorageUtil.GetFormValue(akActor, "zad_Equipped" + LookupDeviceType(kw) + "_Inventory")
		if !equipOrUnequip && tmpInv
			Form tmpRend = StorageUtil.GetFormValue(akActor, "zad_Equipped" + LookupDeviceType(kw) + "_Rendered")
				RemoveDevice(akActor, tmpInv as Armor, tmpRend as Armor, kw, skipEvents=skipEvents, skipMutex=skipMutex)
			return true
			EndIf
		if equipOrUnequip
			EquipDevice(akActor, device, loc_rd, kw, skipEvents = skipEvents, skipMutex = skipMutex)
		else
			RemoveDevice(akActor, device, loc_rd, kw, skipEvents = skipEvents, skipMutex = skipMutex)
		EndIf
		manipulated = true
	EndIf
	return manipulated
EndFunction

; Returns true if a device was successfully manipulated.
; Deprecated: Use UnlockDevicebyKeyword() for unlocks. Was there EVER a use-case for this function for -equipping- devices anyway?
bool Function ManipulateGenericDeviceByKeyword(Actor akActor, Keyword kw, bool equipOrUnequip, bool skipEvents = false, bool skipMutex = false)
        ; First, check to see if the actor is already wearing this device. If he is, save processing time.
        Form tmpInv = StorageUtil.GetFormValue(akActor, "zad_Equipped" + LookupDeviceType(kw) + "_Inventory")
        if !equipOrUnequip && tmpInv
		Form tmpRend = StorageUtil.GetFormValue(akActor, "zad_Equipped" + LookupDeviceType(kw) + "_Rendered")
		if tmpInv.HasKeyword(zad_BlockGeneric) || tmpRend.HasKeyword(zad_BlockGeneric) || tmpInv.HasKeyword(zad_QuestItem) || tmpRend.HasKeyword(zad_QuestItem)
			warn("ManipulateGenericDeviceByKeyword called on non-generic device!")
			return false
		EndIf
     		RemoveDevice(akActor, tmpInv as Armor, tmpRend as Armor, kw, skipEvents=skipEvents, skipMutex=skipMutex)
			return true
        EndIf
	Int iFormIndex = akActor.GetNumItems()
	bool breakFlag = false
	While iFormIndex > 0 && !breakFlag
		iFormIndex -= 1
		Form kForm = akActor.GetNthForm(iFormIndex)
		If kForm.HasKeyword(zad_InventoryDevice) && (((akActor.IsEquipped(kForm) || akActor != playerRef) && !equipOrUnequip) || (!akActor.IsEquipped(kForm) && equipOrUnequip))
			ObjectReference tmpORef = akActor.placeAtMe(kForm, abInitiallyDisabled = true)
			zadEquipScript tmpZRef = tmpORef as zadEquipScript
			if tmpZRef != none && tmpZRef.zad_DeviousDevice == kw && ((akActor.GetItemCount(tmpZRef.deviceRendered) > 0 && !equipOrUnequip) || equipOrUnequip)
				if !tmpZref.HasKeyword(zad_BlockGeneric) && !tmpZref.HasKeyword(zad_QuestItem)
					breakFlag = True
					if equipOrUnequip
						EquipDevice(akActor, kForm as Armor, tmpZRef.deviceRendered, tmpZRef.zad_DeviousDevice, skipEvents = skipEvents, skipMutex = skipMutex)
					else
						RemoveDevice(akActor, kForm as Armor, tmpZRef.deviceRendered, tmpZRef.zad_DeviousDevice, skipEvents = skipEvents, skipMutex = skipMutex)
					EndIf
				EndIf
			EndIf
			tmpORef.delete()
		EndIf				
	EndWhile
	return breakFlag
EndFunction

; Force equips an item on an actor even when a (generic) device of that type is already worn. This will NOT work on quest/custom devices. 
; Returns true if the item was equipped successfully, otherwise false.
; Deprecated: Use LockDevice() with force = true instead
Bool Function ForceEquipDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool skipEvents=false, bool skipMutex = True)	
	if WearingConflictingDevice(akActor, deviceRendered, zad_DeviousDevice)
		Log("ForceEquipDevice() called for one device, while already wearing a device of the same type:" + zad_DeviousDevice)
		If ManipulateGenericDeviceByKeyword(akActor, zad_DeviousDevice, equipOrUnequip = False, skipEvents = skipEvents, skipMutex = skipMutex)
			Log("Force equip: Conflicting item removed successfully!")
		Else
			Log("Force equip: Failed to remove worn item. Aborting.")			
			return False
		EndIf
	EndIf
	if akActor.GetItemCount(deviceInventory) <=0
		akActor.AddItem(deviceInventory, 1, true)
	EndIf		
	akActor.EquipItemEx(deviceInventory, 0, false, true)	
	return True
EndFunction

; Deprecated, do NOT use. This function will be removed in a later version. Use LockDevice() or UnlockDevice()
Function ManipulateDevice(actor akActor, armor device, bool equipOrUnequip, bool skipEvents = false)
	log("WARNING: ManipulateDevice() is deprecated and will be removed in a later DD version! Use LockDevice() instead.")
	; w2b table
	Armor deviceRendered
	Keyword deviceKeyword
	if device == beltPadded
		deviceRendered = beltPaddedRendered
		deviceKeyword = zad_DeviousBelt
	ElseIf device == beltIron
		deviceRendered = beltIronRendered
		deviceKeyword = zad_DeviousBelt
	ElseIf device == plugIron
		deviceRendered = plugIronRendered
		deviceKeyword = zad_DeviousPlug
	ElseIf device == plugPrimitive
		deviceRendered = plugPrimitiveRendered
		deviceKeyword = zad_DeviousPlug
	ElseIf device == plugInflatable
		deviceRendered = plugInflatableRendered
		deviceKeyword = zad_DeviousPlug
	ElseIf device == plugSoulgem
		deviceRendered = plugSoulgemRendered
		deviceKeyword = zad_DeviousPlug
	ElseIf device == braPadded
		deviceRendered = braPaddedRendered
		deviceKeyword = zad_DeviousBra
	ElseIf device == cuffsPaddedArms
		deviceRendered = cuffsPaddedArmsRendered
		deviceKeyword = zad_DeviousArmCuffs
	ElseIf device == cuffsPaddedLegs
		deviceRendered = cuffsPaddedLegsRendered
		deviceKeyword = zad_deviousLegCuffs
	ElseIf device == cuffsPaddedCollar
		deviceRendered = cuffsPaddedCollarRendered
		deviceKeyword = zad_deviousCollar
	ElseIf device == cuffsPaddedComplete
		deviceRendered = cuffsPaddedCompleteRendered
		deviceKeyword = zad_DeviousArmCuffs
	ElseIf device == collarPosture
		deviceRendered = collarPostureRendered
		deviceKeyword = zad_DeviousCollar
	ElseIf device == collarPostureLeather
		deviceRendered = collarPostureLeatherRendered
		deviceKeyword = zad_DeviousCollar
	ElseIf device == armbinder
		deviceRendered = armbinderRendered
		deviceKeyword = zad_DeviousArmbinder
	ElseIf device == gagBall
		deviceRendered = gagBallRendered
		deviceKeyword = zad_DeviousGag
	ElseIf device == gagPanel
		deviceRendered = gagPanelRendered
		deviceKeyword = zad_DeviousGag
	ElseIf device == gagRing
		deviceRendered = gagRingRendered
		deviceKeyword = zad_DeviousGag
	ElseIf device == gagStrapBall
		deviceRendered=gagStrapBallRendered
		deviceKeyword = zad_DeviousGag
	ElseIf device == gagStrapRing
		deviceRendered=gagStrapRingRendered
		deviceKeyword = zad_DeviousGag
	ElseIf device == blindfold
		deviceRendered=blindfoldRendered
		deviceKeyword = zad_DeviousBlindfold
	ElseIf device == cuffsLeatherArms
		deviceRendered=cuffsLeatherArmsRendered
		deviceKeyword = zad_DeviousArmCuffs
	ElseIf device == cuffsLeatherLegs
		deviceRendered=cuffsLeatherLegsRendered
		deviceKeyword = zad_DeviousLegCuffs
	ElseIf device == cuffsLeatherCollar
		deviceRendered=cuffsLeatherCollarRendered
		deviceKeyword = zad_DeviousCollar
	ElseIf device == harnessBody
		deviceRendered=harnessBodyRendered
		deviceKeyword = zad_DeviousHarness
	ElseIf device == harnessCollar
		deviceRendered=harnessCollarRendered
		deviceKeyword = zad_DeviousCollar
	ElseIf device == plugIronVag
		deviceRendered = plugIronVagRendered
		deviceKeyword = zad_DeviousPlugVaginal
	ElseIf device == plugIronAn
		deviceRendered = plugIronAnRendered
		deviceKeyword = zad_DeviousPlugAnal
	ElseIf device == plugPrimitiveVag
		deviceRendered = plugPrimitiveVagRendered
		deviceKeyword = zad_DeviousPlugVaginal
	ElseIf device == plugPrimitiveAn
		deviceRendered = plugPrimitiveAnRendered
		deviceKeyword = zad_DeviousPlugAnal
	ElseIf device == plugSoulgemVag
		deviceRendered = plugSoulgemVagRendered
		deviceKeyword = zad_DeviousPlugVaginal
	ElseIf device == plugSoulgemAn
		deviceRendered = plugSoulgemAnRendered
		deviceKeyword = zad_DeviousPlugAnal
	ElseIf device == plugInflatableVag
		deviceRendered = plugInflatableVagRendered
		deviceKeyword = zad_DeviousPlugVaginal
	ElseIf device == plugInflatableAn
		deviceRendered = plugInflatableAnRendered
		deviceKeyword = zad_DeviousPlugAnal
	ElseIf device == beltPaddedOpen
		deviceRendered = beltPaddedOpenRendered
		deviceKeyword = zad_DeviousBelt
	ElseIf device ==  plugChargeableVag
		deviceRendered = plugChargeableRenderedVag
		deviceKeyword = zad_DeviousPlugVaginal
	ElseIf device ==  plugTrainingVag
		deviceRendered = plugTrainingRenderedVag
		deviceKeyword = zad_DeviousPlugVaginal
	ElseIf device == piercingNSoul
		deviceRendered = piercingNSoulRendered
		deviceKeyword = zad_DeviousPiercingsNipple
	ElseIf device == piercingVSoul
		deviceRendered = piercingVSoulRendered
		deviceKeyword = zad_DeviousPiercingsVaginal
	ElseIf device == collarRestrictive 
		deviceRendered = collarRestrictiveRendered
		deviceKeyword = zad_DeviousCollar
	ElseIf device == corset 
		deviceRendered = corsetRendered
		deviceKeyword = zad_DeviousCorset
	ElseIf device == glovesRestrictive 
		deviceRendered = glovesRestrictiveRendered
		deviceKeyword =zad_DeviousGloves
	ElseIf device == yoke 
		deviceRendered = yokeRendered
		deviceKeyword =zad_DeviousYoke
	Else
		Error("ManipulateDevice did not recognize device type that it received as an argument.")
		return
	EndIf
	if equipOrUnequip
		EquipDevice(akActor, device, deviceRendered, deviceKeyword, skipEvents = skipEvents)
	else
		RemoveDevice(akActor, device, deviceRendered, deviceKeyword, skipEvents = skipEvents)
	EndIf
EndFunction

; Tag database. Deprecated. Do not use! This feature puts a LOT of strain on the scripting engine and doesn't scale well, given the amount of devices now in DD. 
; It has been semi-deprecated since DD4 and doesn't contain most newer DDX devices anyway.
; Use form lists for random picks instead. DD5 doesn't need hard-to-determine parameters for equipping devices anymore, so that approach is MUCH more performant than this one.

Function RegisterDevices()
	RegisterGenericDevice(braPadded 			, "bra,metal,padded, DDi")
	RegisterGenericDevice(cuffsPaddedArms 		, "cuffs,arms,metal,padded, DDi")
	RegisterGenericDevice(cuffsPaddedLegs		, "cuffs,legs,metal,padded, DDi")
	RegisterGenericDevice(cuffsPaddedCollar	, "collar,metal,padded,short, DDi")
	RegisterGenericDevice(collarPosture		, "collar,metal,posture,padded, DDi")
	RegisterGenericDevice(armbinder				, "armbinder,leather,black, DDi")
	RegisterGenericDevice(gagBall				, "gag,harness,ball,leather,black, DDi")
	RegisterGenericDevice(gagPanel				, "gag,harness,panel,leather,black, DDi")
	RegisterGenericDevice(gagRing				, "gag,harness,ring,leather,black, DDi")
	RegisterGenericDevice(gagStrapBall			, "gag,strap,ball,leather,black, DDi")
	RegisterGenericDevice(gagStrapRing			, "gag,strap,ring,leather,black, DDi")
	RegisterGenericDevice(blindfold				, "blindfold,leather,black, DDi")
	RegisterGenericDevice(cuffsLeatherArms		, "cuffs,arms,leather,black, DDi")
	RegisterGenericDevice(cuffsLeatherLegs		, "cuffs,legs,leather,black, DDi")
	RegisterGenericDevice(cuffsLeatherCollar	, "collar,leather,black,short, DDi")
	RegisterGenericDevice(collarPostureLeather, "collar,leather,black,posture, DDi")
	RegisterGenericDevice(harnessBody			, "harness,leather,black,full, DDi")
	RegisterGenericDevice(harnessCollar		, "collar,harness,leather,black, DDi")
	RegisterGenericDevice(plugIronVag			, "plug,vaginal,iron,simple, DDi")
	RegisterGenericDevice(plugIronAn			, "plug,anal,iron,simple, DDi")
	RegisterGenericDevice(plugPrimitiveVag		, "plug,vaginal,primitive,simple, DDi")
	RegisterGenericDevice(plugPrimitiveAn		, "plug,anal,primitive,simple, DDi")
	RegisterGenericDevice(plugSoulgemVag		, "plug,vaginal,soulgem,magic, DDi")
	RegisterGenericDevice(plugSoulgemAn		, "plug,anal,soulgem,magic, DDi")
	RegisterGenericDevice(plugInflatableVag	, "plug,pump,vaginal,inflatable, DDi")
	RegisterGenericDevice(plugInflatableAn		, "plug,pump,anal,inflatable, DDi")
	RegisterGenericDevice(beltPaddedOpen		, "belt,metal,padded,open, DDi")
	RegisterGenericDevice(beltPadded			, "belt,metal,padded,full, DDi")
	RegisterGenericDevice(beltIron				, "belt,metal,iron,full, DDi")
	RegisterGenericDevice(piercingNSoul		, "piercing,nipple,soulgem, DDi")
	RegisterGenericDevice(piercingVSoul		, "piercing,vaginal,soulgem, DDi")

	RegisterGenericDevice(collarRestrictive, "DDi,koffii,collar,restrictive,metal,black")
	RegisterGenericDevice(corset, "DDi,restrictive,corset,leather,black")
	RegisterGenericDevice(glovesRestrictive, "DDi,restrictive,gloves,leather,black")
	RegisterGenericDevice(yoke, "DDi,yoke,metal")

	log("Finished registering devices.")
EndFunction

; Register a device to be used by GetGenericDeviceByKeyword()
Function RegisterGenericDevice(Armor inventoryDevice, String tags)
	if inventoryDevice == none || inventoryDevice.HasKeyword(zad_BlockGeneric) || inventoryDevice.HasKeyword(zad_QuestItem) || !inventoryDevice.hasKeyword(zad_InventoryDevice)
		return
	endIf
	
	Keyword kw = GetDeviceKeyword(inventoryDevice)
	if kw == none
		return
	endIf
	
	StorageUtil.FormListAdd(kw, "zad.GenericDevice", inventoryDevice, false)
	StorageUtil.StringListClear(inventoryDevice, "zad.deviceTags") ; Allow changing tags 
	String[] tagArray = PapyrusUtil.StringSplit(tags, ",")
	int i = tagArray.length
	while i > 0
		i -= 1
		log("adding tag " + tagArray[i] + " for " + inventoryDevice.GetName())
		StorageUtil.StringListAdd(inventoryDevice, "zad.deviceTags", tagArray[i])
	endWhile
EndFunction

; Retrieves a random inventory device with the given keyword, returns none if no devices are available
Armor Function GetGenericDeviceByKeyword(Keyword kw)
	int n = StorageUtil.FormListCount(kw, "zad.GenericDevice")
	Armor device = none
	while device == none && n > 0
		; Fetch a random device
		int i = Utility.RandomInt(0, n - 1)
		device = StorageUtil.FormListGet(kw, "zad.GenericDevice", i) as Armor
		if device == none
			; Remove the index from the list if it's none, and avoid clearing the list completely
			log("Found a none stored generic item, clearing...")
			StorageUtil.FormListRemoveAt(kw, "zad.GenericDevice", i)
			n = StorageUtil.FormListCount(kw, "zad.GenericDevice")
		endIf
	endWhile

	return device 
EndFunction

; Retrieves a random inventory device with the given keyword and tag combination
; If requireAll is true, ALL tags need to be found on the item to be returned
; If fallback is true, a completely random device with the same keyword is returned if tag search fails
Armor Function GetDeviceByTags(Keyword kw, String tags, bool requireAll = true, String tagsToSuppress = "", bool fallBack = true)
	log("GetDeviceByTags("+kw+", "+tags+")")
	String[] tagArray = PapyrusUtil.StringSplit(tags, ",")
	String[] supArray = PapyrusUtil.StringSplit(tagsToSuppress, ",")
	Form[] resultList = new Form[64]
	int n = 0
	
	int i = StorageUtil.FormListCount(kw, "zad.GenericDevice")
	While i > 0
		i -= 1
		Armor current = StorageUtil.FormListGet(kw, "zad.GenericDevice", i) as Armor
		If current && HasTags(current, tagArray, requireAll) && !HasTags(current, supArray, false)
			resultList[n]	= current
			n += 1
		ElseIf current == none
			StorageUtil.FormListRemoveAt(kw, "zad.GenericDevice", i)
		EndIf
	EndWhile
	
	if n < 1 && fallBack
		log("No devices found with tags, falling back to random device")
		return GetGenericDeviceByKeyword(kw)
	ElseIf n < 1
		log("No devices found with tags")
		return none
	endIf
	return resultList[Utility.RandomInt(0, n - 1)] as Armor
EndFunction

; Returns true if the given item has the given tag
bool Function HasTag(Armor item, String tag)
	int i = StorageUtil.StringListCount(item, "zad.deviceTags")
	while i > 0
		i -= 1
		If StorageUtil.StringListGet(item, "zad.deviceTags", i) == tag
			return true 
		EndIf
	endWhile
	return false
EndFunction

; Returns true if the given item has the given tags, if requireAll true, all the tags need to be found on the item
bool Function HasTags(Armor item, String[] tags, bool requireAll = true)
	if tags.length < 1
		return false
	endIf

	int i = StorageUtil.StringListCount(item, "zad.deviceTags")
	int n = 0
	int j
	while i > 0
		i -= 1
		j = tags.length
		String currentTag = StorageUtil.StringListGet(item, "zad.deviceTags", i)
		While j > 0
			j -= 1
			If currentTag == tags[j]
				If !requireAll
					return true
				EndIf
				n += 1
				j = 0 ; break
			EndIf
		endWhile
	endWhile
	return n == tags.length
EndFunction

Function CorsetMagic(actor akActor)
	return
EndFunction

bool Function UpdateCorsetState(actor akActor)
	return false
EndFunction

function enableVA()
  if EnableVRSupport
    _vrikActions.VAC_allTime = True
    _vrikActions.VAC_HandMode = 0
    _vrikActions.VAC_noMove_HandMode = 0
    _vrikActions.VAC_noControl_HandMode = 0
    _vrikActions.EnableVA()
  EndIf
EndFunction

function disableVA()
  if EnableVRSupport
    _vrikActions.VAC_allTime = False
  EndIf
  ; vrikActions.DisableVA()
EndFunction
