% Constants
var infinity    : real := 2147483647 % 2^31 - 1
var pi          : real := Math.PI

% Utility Functions

function degrees_to_radians(degrees : real) : real
    result degrees * Math.PI / 180.0
end degrees_to_radians

% Common Headers
include "interval.t"
include "vec3.t"
include "ray.t"
include "window.t"