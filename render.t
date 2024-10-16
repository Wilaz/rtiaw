include "set_pixel.t"
include "hittable_list.t"

function ray_color(r : ^ray, world : ^hittable) : ^vec3
    var rec : ^hit_record
    new rec
    if (world -> hit(r, 0, 65536, rec)) then
        result fvmul(0.5, vadd(rec -> normal, vinit(1,1,1)))
    end if

    var unit_direction : ^vec3 := unit_vector(r -> direction)
    var a : real := 0.5 * (unit_direction -> y + 1.0)

    var col : ^vec3 :=
        vadd(
            fvmul(
                (1.0-a),
                vinit(1.0, 1.0, 1.0)
            ),
            fvmul
            (
                a,
                vinit(0.5, 0.7, 1.0)
            )
        )

    result col
end ray_color

procedure render(width, height : int)
    var world : ^hittable_list
    new world

    world -> add(sinit(vinit(0,0,-1), 0.5))
    world -> add(sinit(vinit(0,-100.5,-1), 100))

    for x : 0 .. width
        for y : 0 .. height

            var pixel_center : ^vec3 :=
                vadd(
                    pixel00_loc,
                    vadd(
                        fvmul(x, pixel_delta_u),
                        fvmul(y, pixel_delta_v)
                    )
                )

            var ray_direction : ^vec3 :=
                vsub(
                    pixel_center,
                    camera_center
                )

            var r : ^ray := rinit(camera_center, ray_direction)
            var pixel_color : ^vec3 := ray_color(r, world)

            vSetPixel(x, y, pixel_color)

        end for
    end for
end render