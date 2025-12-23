type ray:
    record
        origin, direction : vec3
    end record

% Ray initalizer
function rinit(origin, direction: vec3) : ray
    var r : ray
    r.origin := origin
    r.direction := direction
    result r
end rinit

% Misc ray functions
function rat(r : ray, t : real) : vec3
    result vadd(r.origin, smul(r.direction, t))
end rat
