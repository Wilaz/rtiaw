class ray
    import vec3, vadd, fvmul
    export initialize, origin, direction, at

    var orig : ^vec3
    var dir : ^vec3

    procedure initialize(origin : ^vec3, direction : ^vec3)
	    orig := origin
	    dir := direction
    end initialize

    function origin : ^vec3
        result orig
    end origin

    function direction : ^vec3
        result dir
    end direction

    function at(t : real) : ^vec3
        var tmp : ^vec3 := fvmul(t, dir)
        var res : ^vec3 := vadd(orig, tmp)
        free tmp
        result res
    end at
end ray

function rinit(orig : ^vec3, dir : ^vec3) : ^ray
    var r : ^ray
    new r
    r -> initialize(orig, dir)
    result r
end rinit