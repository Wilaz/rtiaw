include "hittable.t"

% Base
class material
    import ray, hit_record_, vec3, rinit
    export scatter

    deferred function scatter(r_in : ray, rec : ^hit_record_, var attenuation : vec3, var scattered : ray) : boolean
end material

% Lambertian
class lambertian
    inherit material
    import near_zero, vadd, random_unit_vector
    export var albedo

    var albedo : vec3

    body function scatter(r_in : ray, rec : ^hit_record_, var attenuation : vec3, var scattered : ray) : boolean
        var scatter_direction : vec3 := vadd(rec -> normal, random_unit_vector)

        if near_zero(scatter_direction) then
            scatter_direction := rec -> normal
        end if

        scattered := rinit(rec -> p, scatter_direction)
        attenuation := albedo
        result true
    end scatter
end lambertian

function lbinit(albedo: vec3) : ^lambertian
    var m : ^lambertian
    new m
    m -> albedo := albedo
    result m
end lbinit

% Metal
class metal
    inherit material
    import reflect, vadd, vmul, random_unit_vector, unit_vector, dot
    export var albedo, var fuzz

    var albedo : vec3
    var fuzz : real


    body function scatter(r_in : ray, rec : ^hit_record_, var attenuation : vec3, var scattered : ray) : boolean
        var reflected : vec3 := reflect(r_in.direction, rec -> normal)
        reflected := vadd(unit_vector(reflected), smul(random_unit_vector, fuzz))
        scattered := rinit(rec -> p, reflected)
        attenuation := albedo

        result dot(scattered.direction, rec -> normal) > 0.0
    end scatter

end metal

function minit(albedo : vec3, fuzz : real) : ^metal
    var m : ^metal
    new m
    m -> albedo := albedo
    if fuzz < 1.0 then
        m -> fuzz := fuzz
    else
        m -> fuzz := 1.0
    end if
    result m
end minit

% Lord forgive me for what i'm about to do...
class hit_record
    inherit hit_record_
    import material
    export var mat
    var mat : ^material
end hit_record

procedure seth(o, n: ^hit_record)
    o -> p := n -> p
    o -> normal := n -> normal
    o -> t := n -> t
    o -> front_face := n -> front_face
    o -> mat := n -> mat
end seth

class hittable
    import ray, hit_record, interval
    export hit

    deferred function hit(r : ray, ray_t : interval, var rec : ^hit_record) : boolean
end hittable
