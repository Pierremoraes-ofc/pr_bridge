-- Legacy names and argument validation; calculations live in PR Bridge.
local native = lib.__native('bridge/utils/numbers')
lib.math = math
math.toscalars, math.tovector, math.torgba = native.toScalars, native.toVector, native.toRGBA
math.normaltorotation, math.hextorgb = native.normalToRotation, native.hexToRGB
math.tohex, math.groupdigits, math.clamp = native.toHex, native.groupdigits, native.clamp
math.interp, math.round = native.lerp, native.round
function math.lerp(first, last, duration)
    local kind = type(first)
    assert(kind == type(last) and (kind == 'number' or kind == 'table' or kind:match('^vector[234]$')), 'invalid interpolation values')
    return native.Lerp(first, last, duration)
end
return lib.math
