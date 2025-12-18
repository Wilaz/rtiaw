class ray
    import vec3, vadd, smul
    export initialize, origin, direction, at

    var origin : vec3
    var direction : vec3

    procedure initialize(origin_ : vec3, direction_ : vec3)
	    origin := origin_
	    direction := direction_
    end initialize

    function at(t : real) : vec3
        result vadd(origin, smul(direction, t))
    end at
end ray

function rinit(origin : vec3, direction : vec3) : ^ray
    var r : ^ray
    new r
    r -> initialize(origin, direction)
    result r
end rinit
