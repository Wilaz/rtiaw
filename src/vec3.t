type vec3:
    record
        x : real
        y : real
        z : real
    end record

% Vector initalizer
function vinit(x_, y_, z_ : real) : vec3
    var v : vec3
    v.x := x_
    v.y := y_
    v.z := z_
    result v
end vinit

% Addition and subtraction
function vadd(u, v : vec3) : vec3
    result vinit(u.x + v.x, u.y + v.y, u.z + v.z)
end vadd

function vsub(u, v : vec3) : vec3
    result vinit(u.x - v.x, u.y - v.y, u.z - v.z)
end vsub

function negate(u : vec3) : vec3
    result vinit(-u.x, -u.y, -u.z)
end negate

% Multiplication
function vmul(u, v : vec3) : vec3
    result vinit(u.x * v.x, u.y * v.y, u.z * v.z)
end vmul

function smul(v : vec3, t : real) : vec3
    result vinit(v.x * t, v.y * t, v.z * t)
end smul

% Division
function sdiv(v : vec3, t : real) : vec3
    result smul(v, (1/t))
end sdiv

function vdiv(u, v : vec3) : vec3
    result vmul(vdiv(vinit(1,1,1), u), v)
end vdiv

% Length
function len_squared(u : vec3) : real
    result u.x*u.x + u.y*u.y + u.z*u.z
end len_squared

function len(u : vec3) : real
    result sqrt(len_squared(u))
end len

% Misc. vector opperations
function dot(u, v : vec3) : real
    result u.x * v.x + u.y * v.y + u.z * v.z
end dot

function cross(u, v : vec3) : vec3
    result vinit(
        u.y * v.z - u.z * v.y,
        u.z * v.x - u.x * v.z,
        u.x * v.y - u.y * v.x
    )
end cross

function unit_vector(v : vec3) : vec3
    result sdiv(v, len(v))
end unit_vector
