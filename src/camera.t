include "set_pixel.t"

class camera
    import vec3, ray, hit_record, iinit, smul, vadd, vinit, unit_vector, hittable, infinity, vsub, rinit, vSetPixel, winit, vmul, random, sdiv, iuniversef, random_on_hemisphere
    export var aspect_ratio, var image_width, var samples_per_pixel, var window_name, var max_depth, render

    % public
    var aspect_ratio        : real
    var image_width, samples_per_pixel, max_depth : int
    var window_name         : string

    % private
    var image_height        : int
    var center, pixel00_loc, pixel_delta_u, pixel_delta_v : vec3
    var pixel_samples_scale : real

    function ray_color(r : ray, depth : int, world : ^hittable) : vec3
        if depth <= 0 then
            result vinit(0, 0, 0)
        end if

        var col, direction : vec3
        var rec : ^hit_record
        new rec

        if (world -> hit( r, iuniversef, rec )) then
            direction := random_on_hemisphere(rec -> normal)
            col := smul(ray_color(rinit(rec -> p, direction), depth-1, world), 0.5)
            free rec
            result col
        end if

        var a : real := 0.5 * (unit_vector(r.direction).y + 1.0)

        col := vadd(smul(vinit(1.0, 1.0, 1.0), (1.0-a)), smul(vinit(0.5, 0.7, 1.0), a))

        free rec
        result col
    end ray_color

    % private
    procedure initialize()
        var focal_length, viewport_height, viewport_width : real
        var viewport_u, viewport_v, viewport_upper_left : vec3

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
        pixel_delta_u   := sdiv(viewport_u, image_width)
        pixel_delta_v   := sdiv(viewport_v, image_height)

        viewport_upper_left := vsub(vsub(vsub(center, vinit(0, 0, focal_length)), sdiv(viewport_u, 2)), sdiv(viewport_v, 2))
        pixel00_loc := vadd(viewport_upper_left, smul(vmul(pixel_delta_u, pixel_delta_v), 0.5))
    end initialize

    function sample_square : vec3
	    result vinit(random(-0.5, 0.5), random(-0.5, 0.5), 0)
    end sample_square

    function get_ray(x, y : int) : ray
        var pixel_sample, offset : vec3
        offset          :=  sample_square
        pixel_sample    :=  vadd(pixel00_loc, vadd(smul(pixel_delta_u, x + offset.x), smul(pixel_delta_v, y + offset.y)))
        result rinit(center, vsub(pixel_sample, center))
    end get_ray

    procedure render(world : ^hittable)
        initialize
        var pixel_color : vec3

        for x : 0 .. image_width
            for y : 0 .. image_height
                pixel_color := vinit(0, 0, 0)
                for sample : 0 .. samples_per_pixel
                    pixel_color := vadd(pixel_color, ray_color(get_ray(x, y), max_depth, world))
                end for
                vSetPixel(x, y, smul(pixel_color, pixel_samples_scale))
            end for
        end for
    end render
end camera

function cinit(ratio : real, width, samples_per_pixel : int, window_name : string, max_depth : int) : ^camera
    var c : ^camera
    new c
    c -> aspect_ratio      := ratio
    c -> image_width       := width
    c -> samples_per_pixel := samples_per_pixel
    c -> window_name       := window_name
    c -> max_depth         := max_depth
    result c
end cinit