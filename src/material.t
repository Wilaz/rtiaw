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
    import reflect, vadd, vmul, random_unit_vector, unit_vector, dot, smul
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

% Dielectric
class dielectric
    inherit material
    import smul, vinit, unit_vector, dot, reflect, refract, negate
    export var refraction_index

    var refraction_index : real

    function reflectance(cosine, refraction_index : real) : real
        var r0 : real := (1 - refraction_index) / (1 + refraction_index)
        r0 := r0 * r0
        result r0 + (1 - r0) * ((1 - cosine) ** 5)
    end reflectance

    body function scatter(r_in : ray, rec : ^hit_record_, var attenuation : vec3, var scattered : ray) : boolean
        attenuation := vinit(1.0, 1.0, 1.0)

        var ri : real
        if rec -> front_face then
            ri := 1.0 / refraction_index
        else
            ri := refraction_index
        end if

        const unit_direction : vec3 := unit_vector(r_in.direction)
        const cos_theta : real := min(dot(negate(unit_direction), rec -> normal), 1.0)
        const sin_theta : real := sqrt(1.0 - cos_theta * cos_theta)
        const cannot_refract : boolean := ri * sin_theta > 1.0

        var direction : vec3
        if cannot_refract or reflectance(cos_theta, ri) > Rand.Real then
            direction := reflect(unit_direction, rec -> normal)
        else
            direction := refract(unit_direction, rec -> normal, ri)
        end if

        scattered := rinit(rec -> p, direction)
        result true
    end scatter
end dielectric

function dinit(refraction_index: real) : ^dielectric
    var m : ^dielectric
    new m
    m -> refraction_index := refraction_index
    result m
end dinit

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
