include "rtweekend.t"
include "sphere.t"
include "hittable_list.t"
include "camera.t"

var world : ^hittable_list
new world

% Objects
var ground_material : ^lambertian := lbinit(vinit(0.5, 0.5, 0.5))
world -> add(sinit(vinit(0, -1000, 0), 1000, ground_material))

var choose_mat : real
var center : vec3
for a : -11 .. 10
    for b : -11 .. 10
        choose_mat := Rand.Real
        center := vinit(a + 0.9 * Rand.Real, 0.2, b + 0.9 * Rand.Real)

        if len(vsub(center, vinit(4, 0.2, 0))) > 0.9 then
            if choose_mat < 0.8 then
                const albedo : vec3 := vmul(vrandom, vrandom)
                var sphere_material : ^lambertian := lbinit(albedo)
                world -> add(sinit(center, 0.2, sphere_material))
            elsif choose_mat < 0.95 then
                const albedo : vec3 := vcrandom(0.5, 1)
                const fuzz   : real := random(0, 0.5)
                var sphere_material : ^metal := minit(albedo, fuzz)
                world -> add(sinit(center, 0.2, sphere_material))
            else
                var sphere_material : ^dielectric := dinit(1.5);
                world -> add(sinit(center, 0.2, sphere_material))
            end if
        end if
    end for
end for

var material1 : ^dielectric := dinit(1.5)
world -> add(sinit(vinit(0, 1, 0), 1.0, material1))

var material2 : ^lambertian := lbinit(vinit(0.4, 0.2, 0.1))
world -> add(sinit(vinit(-4, 1, 0), 1.0, material2))

var material3 : ^metal      := minit(vinit(0.7, 0.6, 0.5), 0.0)
world -> add(sinit(vinit(4, 1, 0), 1.0, material3))

% Camera
const width  : int  := 1200
const aspect : real := 16.0/9.0
var cam : ^camera
new cam
cam -> aspect_ratio := aspect
cam -> image_width  := width
cam -> samples      := 50
cam -> window_name  := "raytracer"
cam -> max_depth    := 50
cam -> vfov         := 20
cam -> lookfrom     := vinit(13, 2, 3)
cam -> lookat       := vinit( 0, 0, 0)
cam -> vup          := vinit( 0, 1, 0)
cam -> defocus_angle:= 0.6
cam -> focus_dist   := 10.0

% Render
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

Pic.ScreenSave (0, maxy - width div aspect + 1, width - 1, maxy, "./output/" + name + ".bmp")
