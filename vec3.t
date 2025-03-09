class vec3
    export initialize, x, y, z, negative, plus, multiply, divide, len_squared, len

    var x : real
    var y : real
    var z : real

    procedure initialize(xp, yp, zp : real)
	    x := xp
	    y := yp
	    z := zp
    end initialize

    function negative : ^vec3
        var v : ^vec3
        new v
        v -> initialize(-x, -y, -z)
        result v
    end negative

    procedure plus(v : ^vec3)
        x := x + v -> x
        y := y + v -> y
        z := z + v -> z
    end plus

    procedure multiply(t : real)
        x := x * t
        y := y * t
        z := z * t
    end multiply

    procedure divide(t : real)
        self -> multiply(1/t)
    end divide

    function len_squared : real
        result x*x + y*y + z*z
    end len_squared

    function len : real
        result sqrt(len_squared)
    end len
end vec3

% Vector initalizer
function vinit(x, y, z : real) : ^vec3
    var v : ^vec3
    new v
    v -> initialize(x, y, z)
    result v
end vinit

% Addition and subtraction
function vadd(u, v : ^vec3) : ^vec3
    result vinit(u->x + v->x, u->y + v->y, u->z + v->z)
end vadd

function vsub(u, v : ^vec3) : ^vec3
    result vinit(u->x - v->x, u->y - v->y, u->z - v->z)
end vsub

% Multiplication
function vmul(u, v : ^vec3) : ^vec3
    result vinit(u->x * v->x, u->y * v->y, u->z * v->z)
end vmul

function smul(v : ^vec3, t : real) : ^vec3
    result vinit(v->x * t, v->y * t, v->z * t)
end smul

% Division
function sdiv(v : ^vec3, t : real) : ^vec3
    result smul(v, (1/t))
end sdiv

function vdiv(u, v : ^vec3) : ^vec3
    var temp : ^vec3
    var res : ^vec3

    temp := sdiv(u, 1)
    res  := vmul(temp, v)
    free temp

    result res
end vdiv

% Misc. vector opperations
function dot(u, v : ^vec3) : real
    result (u -> x * v -> x) + (u -> y * v -> y) + (u -> z * v -> z)
end dot

function cross(u, v : ^vec3) : ^vec3
    result vinit(
        u -> y * v -> z - u -> z * v -> y,
        u -> z * v -> x - u -> x * v -> z,
        u -> x * v -> y - u -> y * v -> x
    )
end cross

function unit_vector(v : ^vec3) : ^vec3
    result sdiv(v, v -> len)
end unit_vector
