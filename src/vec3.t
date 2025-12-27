type vec3:
    record
        x, y, z : real
    end record

% Vector initalizer
function vinit(x, y, z : real) : vec3
    var v : vec3
    v.x := x
    v.y := y
    v.z := z
    result v
end vinit

    % Addition and subtraction
function vadd(u, v : vec3) : vec3
        result vinit(u.x + v.x, u.y + v.y, u.z + v.z)
end vadd

function vsub(u, v : vec3) : vec3
        result vinit(u.x - v.x, u.y - v.y, u.z - v.z)
end vsub

function negate(v : vec3) : vec3
    result vinit(-v.x, -v.y, -v.z)
end negate

    % Multiplication
function vmul(u, v : vec3) : vec3
        result vinit(u.x * v.x, u.y * v.y, u.z * v.z)
end vmul

function smul(v : vec3, t : real) : vec3
    result vinit(v.x * t, v.y * t, v.z * t)
end smul

% Division
function vdiv(u, v : vec3) : vec3
    result vmul(vdiv(vinit(1,1,1), u), v)
end vdiv

function sdiv(v : vec3, t : real) : vec3
    result smul(v, (1/t))
end sdiv

% Length
function len_squared(v : vec3) : real
    result v.x*v.x + v.y*v.y + v.z*v.z
end len_squared

function len(v : vec3) : real
    result sqrt(len_squared(v))
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

function near_zero(v : vec3) : boolean
    result abs(v.x) <= Limits.MinExp and abs(v.y) <= Limits.MinExp and abs(v.z) <= Limits.MinExp
end near_zero

% Random
function vrandom : vec3
    result vinit(Rand.Real, Rand.Real, Rand.Real)
end vrandom

function vcrandom(min, max : real) : vec3
    result vinit(random(min, max), random(min, max), random(min, max))
end vcrandom

function random_unit_vector : vec3
    var p     : vec3
    var lensq : real
    loop
        p     := vcrandom(-1, 1)
        lensq := len_squared(p)
        exit when Limits.MinExp < lensq and lensq <= 1.0
    end loop
    result sdiv(p, sqrt(lensq))
end random_unit_vector

function random_on_hemisphere(normal : vec3) : vec3
    const on_unit_sphere : vec3 := random_unit_vector

    if dot(on_unit_sphere, normal) > 0.0 then
        result on_unit_sphere
    else
        result negate(on_unit_sphere)
    end if
end random_on_hemisphere

function random_in_unit_disk : vec3
    var p : vec3
    loop
        p := vinit(random(-1,1), random(-1,1), 0);
        exit when len_squared(p) < 1
    end loop
    result p
end random_in_unit_disk

% Materials
function reflect(v, n : vec3) : vec3
    result vsub(v, smul(smul(n, dot(v, n)), 2))
end reflect

function refract(uv, n : vec3, etai_over_etat : real) : vec3
    const cos_theta      : real := min(dot(negate(uv), n), 1.0)
    const r_out_perp     : vec3 := smul(vadd(uv, smul(n, cos_theta)), etai_over_etat)
    const r_out_parallel : vec3 := smul(n, 0 - sqrt(abs(1.0 - len_squared(r_out_perp))))
    result vadd(r_out_perp, r_out_parallel)
end refract
