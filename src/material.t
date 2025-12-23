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
    import reflect
    export var albedo

    var albedo : vec3

    body function scatter(r_in : ray, rec : ^hit_record_, var attenuation : vec3, var scattered : ray) : boolean
        scattered := rinit(rec -> p, reflect(r_in.direction, rec -> normal))
        attenuation := albedo

        result true
    end scatter

end metal

function minit(albedo: vec3) : ^metal
    var m : ^metal
    new m
    m -> albedo := albedo
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
