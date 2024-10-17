class sphere
    inherit hittable
    import vec3, dot, vsub, vfdiv
    export initialize

    var center  : ^vec3
    var radius  : real

    procedure initialize(cent : ^vec3, rad : real)
        center := cent
        radius := max(0, rad)
    end initialize

    body function hit(r : ^ray, ray_t : ^interval, rec : ^hit_record) : boolean
        var oc              : ^vec3 := vsub(center, r -> origin)
        var a               : real  := r -> direction -> len_squared
        var h               : real  := dot(r -> direction, oc)
        var c               : real  := (oc -> len_squared) - (radius * radius)
        var discriminant    : real  := (h * h) - (a*c)

        if (discriminant < 0) then
            result false
        end if

        var sqrtd : real := sqrt(discriminant)
        var root : real := (h - sqrtd) / a

        if not ray_t -> surrounds(root) then
            root := (h + sqrtd) / a

            if not ray_t -> surrounds(root) then
                result false
            end if
        end if

        rec -> sett(root)
        rec -> setp(r -> at(rec -> t))

        var outward_normal : ^vec3 := vfdiv(vsub(rec -> p, center), radius)
        rec -> set_face_normal(r, outward_normal)

        result true
    end hit
end sphere

function sinit(center : ^vec3, radius : real) : ^sphere
    var s : ^sphere
    new s
    s -> initialize(center, radius)
    result s
end sinit