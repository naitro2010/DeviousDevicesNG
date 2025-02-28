Scriptname zadSLBoundAnims extends sslAnimationFactory

SexlabFramework Property Sexlab Auto
zadLibs Property libs Auto
zadBQ00 Property filterQuest Auto

;This sets up bound animations for private use.
;They will not populate the general sexlab list and must be called specifically.

;Define animation prefixes for each actor (must correspond to names in FNIS), add more if necessary

function LoadAnimations()
	libs.log("Devious Devices is now creating bound animations.")
	SexLab = SexLabUtil.GetAPI()
	If SexLab == None
		libs.Error("Animation registration failed: SexLab is none.")
	EndIf
	if filterQuest == None
		libs.Error("Animation registration failed: FilterQuest is none.")
	EndIf
	;-------------------
	;PET SUIT ANIMATIONS - the only restraint category that still needs dedicated animations registered
	;-------------------
	;blowjob
	SexLab.GetSetAnimationObject("DD_B_PS_DT", "CreateDD_B_PS_DT", filterQuest)
	;vaginal
	SexLab.GetSetAnimationObject("DD_B_PS_Doggy", "CreateDD_B_PS_Doggy", filterQuest)
	SexLab.GetSetAnimationObject("DD_B_PS_Miss", "CreateDD_B_PS_Miss", filterQuest)
	;anal
	SexLab.GetSetAnimationObject("DD_B_PS_DoggyA", "CreateDD_B_PS_DoggyA", filterQuest)
EndFunction