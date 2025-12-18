class hit_record
    import vec3, ray, dot, negate
    export  var p, var t, normal, front_face, set_face_normal, sets

    var     p, normal   : vec3
    var     t           : real
    var     front_face  : boolean

    procedure set_face_normal(r : ray, outward_normal : vec3)
        front_face := dot(r.direction, outward_normal) < 0
        if front_face then
            normal := outward_normal
        else
            normal := negate(outward_normal)
        end if
    end set_face_normal

    procedure sets(value : ^hit_record)
        p           := value -> p
        t           := value -> t
        normal      := value -> normal
        front_face  := value -> front_face
    end sets
end hit_record

class hittable
    import ray, hit_record, interval
    export hit

    deferred function hit(r : ray, ray_t : interval, rec : ^hit_record) : boolean
end hittable