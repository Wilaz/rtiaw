type ray:
    record
        origin : vec3
        direction : vec3
    end record

% Ray initalizer
function rinit(origin_ : vec3, direction_ : vec3) : ray
    var r : ray
    r.origin := origin_
    r.direction := direction_
    result r
end rinit

% Misc ray functions
function rat(r : ray, t : real) : vec3
    result vadd(r.origin, smul(r.direction, t))
end rat
