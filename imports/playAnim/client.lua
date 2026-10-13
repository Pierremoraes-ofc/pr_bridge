local native = lib.__native('bridge/fivem/streaming/client')
function lib.playAnim(ped, dict, clip, blendIn, blendOut, duration, flags, phase, phaseControlled, controlFlags, overrideCloneUpdate)
    local ok, reason = native.playAnim({ped=ped, dict=dict, clip=clip,
        blendIn=blendIn or 8.0, blendOut=blendOut or -8.0, duration=duration or -1,
        flags=flags or 0, playbackRate=phase or 0.0, lockX=phaseControlled or false,
        controlFlags=controlFlags or 0, lockZ=overrideCloneUpdate or false, wait=false, releaseDict=true})
    if not ok then error(reason, 2) end
end
return lib.playAnim
