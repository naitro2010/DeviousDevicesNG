Scriptname zadInterfaceVRIK Hidden

Function EnableVR(Quest _API) Global
    if !_API
        return
    endIf
    vrikActions conf = (_API as _vrikAction_qust_mcm).VRIKActionsConf
    conf.VAC_allTime = True
    conf.VAC_HandMode = 0
    conf.VAC_noMove_HandMode = 0
    conf.VAC_noControl_HandMode = 0
    conf.EnableVA()
EndFunction

Function DisableVR(Quest _API) Global
    if _API
        ((_API as _vrikAction_qust_mcm).VRIKActionsConf as vrikActions).VAC_allTime = False
    endIf
EndFunction