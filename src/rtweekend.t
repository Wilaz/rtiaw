% Constants
const infinity : real := Limits.maxnat
const pi       : real := Math.PI

% Utility Functions
function degrees_to_radians(degrees : real) : real
    result degrees * pi / 180.0
end degrees_to_radians

function random(minimum, maximum : real) : real
    result (maximum - minimum) * Rand.Real + minimum
end random

procedure winit(width, height : int, title : string)
    View.Set("graphics:" + intstr(width) + ";" + intstr(height))
    View.Set("title:" + title)
end winit

% Common Headers
include "interval.t"
include "vec3.t"
include "ray.t"
include "material.t"