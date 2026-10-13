-- ox uses reference-counted controls; the engine itself is native PR.
lib.disableControls = lib.__native('bridge/fivem/controls/client')(true)
return lib.disableControls
