class sphere
    inherit hittable
    import vec3, dot, vsub, sdiv, len_squared, hit_record, rat, isurrounds
    export initialize

    var center  : vec3
    var radius  : real

    procedure initialize(cent : vec3, rad : real)
        center := cent
        radius := max(0, rad)
    end initialize

    body function hit(r : ray, ray_t : interval, rec : ^hit_record) : boolean
        var oc              : vec3 := vsub(center, r.origin)
        var a               : real  := len_squared(r.direction)
        var h               : real  := dot(r.direction, oc)
        var c               : real  := len_squared(oc) - (radius * radius)
        var discriminant    : real  := (h * h) - (a*c)

        if (discriminant < 0) then
            result false
        end if

        var sqrtd : real := sqrt(discriminant)
        var root : real := (h - sqrtd) / a

        if not isurrounds(ray_t, root) then
            root := (h + sqrtd) / a

            if not isurrounds(ray_t, root) then
                result false
            end if
        end if

        rec -> sett(root)
        rec -> setp(rat(r, rec -> t))

        var outward_normal : vec3 := sdiv(vsub(rec -> p, center), radius)
        rec -> set_face_normal(r, outward_normal)

        result true
    end hit
end sphere

function sinit(center : vec3, radius : real) : ^sphere
    var s : ^sphere
    new s
    s -> initialize(center, radius)
    result s
end sinit