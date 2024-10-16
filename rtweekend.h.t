% Constants

var infinity : real := 65536

% Utility Functions

function degrees_to_radians(degrees : real) : real
    result degrees * Math.PI / 180.0
end degrees_to_radians

% Common Headers

include "vec3.t"
include "ray.t"
