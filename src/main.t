const width : int := 100
const samples : int := 10
const max_bounces : int := 30
const aspect_ratio : real := 16.0/9.0

include "rtweekend.t"
include "sphere.t"
include "hittable_list.t"
include "camera.t"

var world : ^hittable_list
new world

var material_ground : ^lambertian := lbinit(vinit(0.8, 0.8, 0.0))
var material_center : ^lambertian := lbinit(vinit(0.1, 0.2, 0.5))
var material_left : ^metal := minit(vinit(0.8, 0.8, 0.8))
var material_right : ^metal := minit(vinit(0.8, 0.6, 0.2))

world -> add(sinit(vinit( 0.0, -100.5, -1.0), 100.0, material_ground))
world -> add(sinit(vinit( 0.0,    0.0, -1.2), 0.5, material_center))
world -> add(sinit(vinit(-1.0,    0.0, -1.0), 0.5, material_left))
world -> add(sinit(vinit( 1.0,    0.0, -1.0), 0.5, material_right))

var cam : ^camera := cinit(aspect_ratio, width, samples, "raytracer", max_bounces)

cam -> render(world)

free world
free cam

% Bypass colon issues
var temp : string :=  Time.Date()
var name : string := ""
for i : 1 .. length(temp)
    if temp(i) = ':' then
        name += "-"
    else
        name += temp(i)
    end if
end for

Pic.ScreenSave (0, maxy-(width div aspect_ratio), width-1, maxy, "./output/" + name + ".bmp")
