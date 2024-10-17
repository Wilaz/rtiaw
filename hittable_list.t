class hittable_list
    inherit hittable
    import iinit
    export clear, add

    var objects : array 0 .. 99 of ^hittable
    var ind : int := 0

    procedure clear
        ind := 0
    end clear

    procedure add(object : ^hittable)
        objects (ind) := object
        ind := ind + 1
    end add

    body function hit(r : ^ray, ray_t : ^interval, rec : ^hit_record) : boolean
        var temp_rec : ^hit_record
        new temp_rec
        var hit_anything : boolean := false
        var closest_so_far : real := ray_t -> imax

        for i : 0 .. ind - 1
            var object : ^hittable := objects (i)
            if object -> hit(r, iinit(ray_t -> imin, closest_so_far), temp_rec) then
                hit_anything    := true
                closest_so_far  := temp_rec -> t
                rec -> sets(temp_rec)
            end if
        end for

        result hit_anything
    end hit
end hittable_list

function hlinit : ^hittable_list
    var h : ^hittable_list
    new h
    result h
end hlinit