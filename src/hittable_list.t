class hittable_list
    inherit hittable
    import iinit
    export clear, add

    var ind : int := 0
    var objects : flexible array 0..0 of ^hittable

    procedure clear
        free objects
        ind := 0
    end clear

    procedure add(object : ^hittable)
        new objects , ind
        objects (ind) := object
        ind := ind + 1
    end add

    body function hit(r : ^ray, ray_t : ^interval, rec : ^hit_record) : boolean
        var temp_rec        : ^hit_record
        var temp_interval   : ^interval
        var hit_anything    : boolean := false
        var closest_so_far  : real := ray_t -> imax

        new temp_rec

        for i : 0 .. ind - 1
            new temp_interval
            temp_interval := iinit(ray_t -> imin, closest_so_far)

            if objects(i) -> hit(r, temp_interval, temp_rec) then
                hit_anything    := true
                closest_so_far  := temp_rec -> t
                rec -> sets(temp_rec)
            end if

            free temp_interval
        end for

        free temp_rec

        result hit_anything
    end hit
end hittable_list

function hlinit : ^hittable_list
    var h : ^hittable_list
    new h
    result h
end hlinit