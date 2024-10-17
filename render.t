include "set_pixel.t"
include "hittable_list.t"



procedure render(width, height : int)
    var world : ^hittable_list
    new world

    world -> add(sinit(vinit(0,0,-1), 0.5))
    world -> add(sinit(vinit(0,-100.5,-1), 100))
end render