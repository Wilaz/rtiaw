class ray
    import vec3, vadd, smul
    export initialize, origin, direction, at

    var origin : ^vec3
    var direction : ^vec3

    procedure initialize(originp : ^vec3, directionp : ^vec3)
	    origin := originp
	    direction := directionp
    end initialize

    function at(t : real) : ^vec3
        var temp : ^vec3 := smul(direction, t)
        var res : ^vec3 := vadd(origin, temp)
        free temp
        result res
    end at
end ray

function rinit(origin : ^vec3, direction : ^vec3) : ^ray
    var r : ^ray
    new r
    r -> initialize(origin, direction)
    result r
end rinit
