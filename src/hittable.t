class hit_record_
    import vec3, ray, dot, negate
    export  var p, var t, var normal, var front_face, set_face_normal

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
end hit_record_
