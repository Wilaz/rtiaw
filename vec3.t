class vec3
    export e, initialize, x, y, z, negative, plus, multiply, divide, len_squared, len

    var e : array 0 .. 2 of real

    procedure initialize(e0, e1, e2 : real)
	    e(0) := e0
	    e(1) := e1
	    e(2) := e2
    end initialize

    function x : real
	    result e (0)
    end x

    function y : real
	    result e (1)
    end y

    function z : real
	    result e (2)
    end z

    function negative : ^vec3
        var v : ^vec3
        new v
        v -> initialize(-x, -y, -z)
        result v
    end negative

    function plus(v : ^vec3) : ^vec3
        e(0) := x() + v -> x()
        e(1) := y() + v -> y()
        e(2) := z() + v -> z()
        result self
    end plus

    function multiply(t : real) : ^vec3
        e(0) := x() * t
        e(1) := y() * t
        e(2) := z() * t
        result self
    end multiply

    function divide(t : real) : ^vec3
        result self -> multiply(1/t)
    end divide

    function len_squared : real
        result e(0)*e(0) + e(1)*e(1) + e(2)*e(2)
    end len_squared

    function len : real
        result sqrt(len_squared)
    end len
end vec3

function vinit(x, y, z : real) : ^vec3
    var v : ^vec3
    new v
    v -> initialize(x, y, z)
    result v
end vinit


function vadd(u, v : ^vec3) : ^vec3
    result vinit(u->x + v->x, u->y + v->y, u->z + v->z)
end vadd

function vsub(u, v : ^vec3) : ^vec3
    result vinit(u->x - v->x, u->y - v->y, u->z - v->z)
end vsub


function vvmul(u, v : ^vec3) : ^vec3
    result vinit(u->x * v->x, u->y * v->y, u->z * v->z)
end vvmul

function vfmul(v : ^vec3, t : real) : ^vec3
    result vinit(v->x * t, v->y * t, v->z * t)
end vfmul

function fvmul(t : real, v : ^vec3) : ^vec3
    result vinit(v->x * t, v->y * t, v->z * t)
end fvmul


function vfdiv(v : ^vec3, t : real) : ^vec3
    result vfmul(v, (1/t))
end vfdiv

function fvdiv(t : real, v : ^vec3) : ^vec3
    result fvmul((1/t), v)
end fvdiv

function vvdiv(u, v : ^vec3) : ^vec3
    result vvmul(fvdiv(1, u), v)
end vvdiv


function dot(u, v : ^vec3) : real
    result (u -> x * v -> x) + (u -> y * v -> y) + (u -> z * v -> z)
end dot

function cross(u, v : ^vec3) : ^vec3
    var x : ^vec3 :=
        vinit(
            u -> y * v -> z - u -> z * v -> y,
            u -> z * v -> x - u -> x * v -> z,
            u -> x * v -> y - u -> y * v -> x
        )
    result x
end cross

function unit_vector(v : ^vec3) : ^vec3
    result vfdiv(v, v -> len)
end unit_vector
