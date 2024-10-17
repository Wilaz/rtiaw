import GUI

include "rtweekend.h.t"
include "hittable.t"
include "sphere.t"
include "hittable_list.t"
include "camera.t"

var world : ^hittable_list := hlinit

world -> add(sinit(vinit(0,0,-1), 0.5))
world -> add(sinit(vinit(0,-100.5,-1), 100))

var cam : ^camera := cinit(16.0/9.0, 400, 100, "raytracer")

cam -> render(world)

Input.Pause