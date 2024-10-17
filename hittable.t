class hit_record
    import vec3, ray, dot
    export  p, normal, t, front_face, set_face_normal, sets, sett, setp

    var     p           : ^vec3
    var     normal      : ^vec3
    var     t           : real
    var     front_face  : boolean

    procedure set_face_normal(r : ^ray, outward_normal : ^vec3)
        front_face := dot(r -> direction, outward_normal) < 0
        if front_face then
            normal := outward_normal
        else
            normal := outward_normal -> negative
        end if
    end set_face_normal

    procedure sets(value : ^hit_record)
        p           := value -> p
        normal      := value -> normal
        t           := value -> t
        front_face  := value -> front_face
    end sets

    procedure sett(nt : real)
        t := nt
    end sett

    procedure setp(np : ^vec3)
        p := np
    end setp
end hit_record

class hittable
    import ray, hit_record, interval
    export hit

    deferred function hit(r : ^ray, ray_t : ^interval, rec : ^hit_record) : boolean
end hittable