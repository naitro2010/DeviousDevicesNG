Scriptname zadMufflingStateScript extends ReferenceAlias  
{The sound muffling mechanic works by manipulating the frequency and volume of SoundCategories. 
 However, these changes persist through game loads. This is undesired functionality for devious devices: the changes should only be active while the devices are worn.
 This script handles the state of the sound categories. A call to UpdateMuffleState will check whether any changes to the sound categories are needed based on worn devices.}

zadLibs Property libs Auto
Actor Property PlayerRef Auto
MagicEffect Property zad_effMuffling Auto
SoundCategory[] Property CategoriesToMuffle Auto
{Array of sound categories that should get less loud when muffling devices are equipped.}
SoundCategory[] Property CategoriesToLouden Auto
{Array of sound categories that should get louder when muffling devices are equipped. This exists so you can muffle a parent sound category and louden its child, to select certain sounds (e.g. UI, or vibe sounds!)}
Sound Property zadMuffledNeutralNoise Auto
{The looping sound that acts as "White noise".}

Int loopSoundInstance = -1

; =================================== API ===================================

Float Property MuffledFrequency = 0.92 Auto
{Frequency shift when a muffling device is equipped. Typically, higher frequencies are absorbed more than lower ones, so you want this to be < 1 for realism. Between 0.8 and 1.0 is usually good.}

Function UpdateMuffleState()
	If loopSoundInstance != -1
		Sound.StopInstance(loopSoundInstance) ; If one is playing, make sure to stop it before starting a new one.
		loopSoundInstance = -1
	EndIf

	If PlayerRef.HasMagicEffect(zad_effMuffling)
		SetSoundCategoryModifiers(frequencyMuffle=MuffledFrequency, volumeMuffle=libs.Config.VolumeMuffled)
		loopSoundInstance = zadMuffledNeutralNoise.Play(PlayerRef)
		Sound.SetInstanceVolume(loopSoundInstance, libs.Config.VolumeMuffleWhiteNoise)
	Else
		; No muffle. Reset to normal.
		SetSoundCategoryModifiers(1.0, 1.0, 1.0, 1.0)
	EndIf
EndFunction

; =================================== INTERNAL======================================

Event OnPlayerLoadGame()
	UpdateMuffleState()
EndEvent

Function SetSoundCategoryModifiers(float frequencyMuffle = 1.0, float volumeMuffle = 1.0, float frequencyLouden = 1.0, float volumeLouden = 1.0)
		;Debug.MessageBox(self + ": Modifying sound catergories" + frequencyMuffle + " " + volumeMuffle + " " + frequencyLouden + " "+ volumeLouden)		

		; Set modifiers for dampened sounds. By convention, these are the ones that should be made less loud.
		int i = CategoriesToMuffle.Length
		While i > 0
			i -= 1
			CategoriesToMuffle[i].SetFrequency(frequencyMuffle)
			CategoriesToMuffle[i].SetVolume(volumeMuffle)
			;Debug.MessageBox("Set sound category" + CategoriesToMuffle[i] + " to frequency " + frequencyMuffle + " and volume " + volumeMuffle)	
		EndWhile

		; Set modifiers for loudened sounds. This exists so you can muffle a parent sound category and louden its child, to select certain sounds (e.g. UI, or vibe sounds!)
		i = CategoriesToLouden.Length
		While i > 0
			i -= 1
			CategoriesToLouden[i].SetFrequency(frequencyLouden)
			CategoriesToLouden[i].SetVolume(volumeLouden)
			;Debug.MessageBox("Set sound category" + CategoriesToLouden[i] + " to frequency " + frequencyLouden + " and volume " + volumeLouden)	
		EndWhile
EndFunction
