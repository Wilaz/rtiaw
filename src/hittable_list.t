class hittable_list
    inherit hittable
    import iinit, seth
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

    body function hit(r : ray, ray_t : interval, var rec : ^hit_record) : boolean
        var temp_rec        : ^hit_record
        var hit_anything    : boolean := false
        var closest_so_far  : real := ray_t.max

        new temp_rec

        for i : 0 .. ind - 1
            if objects(i) -> hit(r, iinit(ray_t.min, closest_so_far), temp_rec) then
                hit_anything    := true
                closest_so_far  := temp_rec -> t
                seth(rec, temp_rec)
                % rec -> set(temp_rec), turing doesn't copy the object
            end if
        end for

        free temp_rec

        result hit_anything
    end hit
end hittable_list
