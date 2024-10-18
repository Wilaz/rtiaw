include "set_pixel.t"

class camera
    import vec3, ray, hit_record, iinit, fvmul, vadd, vinit, unit_vector, hittable, infinity, vsub, rinit, vSetPixel, winit, vfdiv, vvmul, random
    export aspect_ratio, image_width, render, inits, window_name, samples_per_pixel

    % public
    var aspect_ratio        : real
    var image_width         : int
    var samples_per_pixel   : int
    var window_name         : string

    % private
    var image_height        : int
    var center              : ^vec3
    var pixel00_loc         : ^vec3
    var pixel_delta_u       : ^vec3
    var pixel_delta_v       : ^vec3
    var pixel_samples_scale : real

    function ray_color(r : ^ray, world : ^hittable) : ^vec3
        var rec             : ^hit_record
        var unit_direction  : ^vec3
        var a               : real
        var col             : ^vec3
        new rec

        if (world -> hit( r, iinit(0, infinity), rec )) then
            col :=
                fvmul(
                    0.5,
                    vadd(
                        rec -> normal,
                        vinit(1,1,1)))

            result col
        end if

        unit_direction  := unit_vector(r -> direction)
        a               := 0.5 * (unit_direction -> y + 1.0)

        col :=
            vadd(
                fvmul(
                    (1.0-a),
                    vinit(1.0, 1.0, 1.0)),
                fvmul(
                    a,
                    vinit(0.5, 0.7, 1.0)))

        free unit_direction
        free rec

        result col
    end ray_color

    procedure inits(ratio : real, width, samples : int, title : string)
        image_width         := width
        aspect_ratio        := ratio
        samples_per_pixel   := samples
        window_name         := title
    end inits

    % private
    procedure initialize()
        var focal_length        : real
        var viewport_height     : real
        var viewport_width      : real
        var viewport_u          : ^vec3
        var viewport_v          : ^vec3
        var viewport_upper_left : ^vec3

        if (image_width div aspect_ratio) < 1 then
            image_height := 1
        else
            image_height := (image_width div aspect_ratio)
        end if

        pixel_samples_scale := 1.0 / samples_per_pixel

        winit(image_width, image_height, window_name)

        center          := vinit(0, 0, 0)

        focal_length    := 1.0
        viewport_height := 2.0
        viewport_width  := viewport_height * (image_width / image_height)

        viewport_u      := vinit(viewport_width, 0, 0)
        viewport_v      := vinit(0, -viewport_height, 0)

        pixel_delta_u   := vfdiv(viewport_u, image_width)
        pixel_delta_v   := vfdiv(viewport_v, image_height)

        viewport_upper_left :=
                vsub(
                    vsub(
                        vsub(
                            center,
                            vinit(0, 0, focal_length)
                        ),
                        vfdiv(viewport_u, 2)
                    ),
                    vfdiv(viewport_v, 2)
                )

        pixel00_loc         :=
                vadd(
                    viewport_upper_left,
                    fvmul(
                        0.5,
                        vvmul(
                            pixel_delta_u,
                            pixel_delta_v
                        )
                    )
                )
    end initialize

    function sample_square : ^vec3
        result vinit(random(-0.5, 0.5), random(-0.5, 0.5), 0)
    end sample_square

    function get_ray(x, y : int) : ^ray

        var pixel_sample    : ^vec3
        var ray_origin      : ^vec3
        var ray_direction   : ^vec3
        var offset          : ^vec3
        var res             : ^ray

        offset          :=  sample_square
        pixel_sample    :=  vadd(
                                pixel00_loc,
                                vadd(
                                    fvmul( (x + offset -> x), pixel_delta_u ),
                                    fvmul( (y + offset -> y), pixel_delta_v )
                                )
                            )

        ray_origin      := center
        ray_direction   := vsub(pixel_sample, ray_origin)
        res := rinit(ray_origin, ray_direction)

        free offset
        free pixel_sample

        result res
    end get_ray

    procedure render(world : ^hittable)
        initialize
        var pixel_color     : ^vec3
        var r               : ^ray
        new pixel_color

        for x : 0 .. image_width
            for y : 0 .. image_height
                pixel_color -> initialize(0, 0, 0)

                for sample : 0 .. samples_per_pixel
                    r := get_ray(x, y)
                    pixel_color -> plus(ray_color(r, world))
                    free r
                end for
                vSetPixel(x, y, fvmul(pixel_samples_scale, pixel_color))
            end for
        end for

        free pixel_color
    end render
end camera

function cinit(ratio : real, width, samples_per_pixel : int, title : string) : ^camera
    var c : ^camera
    new c
    c -> inits(ratio, width, samples_per_pixel, title)
    result c
end cinit