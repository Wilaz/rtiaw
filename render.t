include "set_pixel.t"

function ray_color(r : ^ray) : ^vec3
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
            var pixel_color : ^vec3 := ray_color(r)

            vSetPixel(x, y, pixel_color)

        end for
    end for
end render