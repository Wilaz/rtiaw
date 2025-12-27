include "set_pixel.t"

class camera
    import vec3, ray, hit_record, iinit, smul, vadd, vinit, unit_vector, hittable, infinity, vsub, rinit, vSetPixel, winit, vmul, random, sdiv, iuniversesf, random_unit_vector, material, len, cross, negate, random_in_unit_disk
    export var aspect_ratio, var image_width, var samples, var window_name, var max_depth, render, var vfov, var lookfrom, var lookat, var vup, var defocus_angle, var focus_dist

    % public
    var aspect_ratio, vfov, defocus_angle, focus_dist : real
    var image_width, samples, max_depth : int
    var window_name         : string
    var lookfrom, lookat, vup : vec3

    aspect_ratio    := 1.0
    image_width     := 100
    samples         := 10
    max_depth       := 10
    vfov            := 90
    lookfrom        := vinit(0,  0,  0)
    lookat          := vinit(0,  0, -1)
    vup             := vinit(0,  1,  0)
    defocus_angle   := 0
    focus_dist      := 10


    % private
    var image_height        : int
    var center, pixel00_loc, pixel_delta_u, pixel_delta_v, u, v, w, defocus_disk_u, defocus_disk_v : vec3
    var pixel_samples_scale : real

    function ray_color(r : ray, depth : int, world : ^hittable) : vec3
        if depth <= 0 then
            result vinit(0, 0, 0)
        end if

        var col, direction : vec3
        var rec : ^hit_record
        new rec

        if world -> hit(r, iuniversesf, rec) then
            var scattered : ray
            var attenuation : vec3
            
            if rec -> mat -> scatter(r, rec, attenuation, scattered) then
                free rec
                result vmul(attenuation, ray_color(scattered, depth-1, world))
            end if
            
            free rec
            result vinit(0,0,0)
        end if

        var a : real := 0.5 * (unit_vector(r.direction).y + 1.0)

        col := vadd(smul(vinit(1.0, 1.0, 1.0), (1.0-a)), smul(vinit(0.5, 0.7, 1.0), a))

        free rec
        result col
    end ray_color

    % private
    procedure initialize()
        var viewport_height, viewport_width, h : real
        var viewport_u, viewport_v, viewport_upper_left : vec3

        if (image_width div aspect_ratio) < 1 then
            image_height := 1
        else
            image_height := (image_width div aspect_ratio)
        end if

        pixel_samples_scale := 1.0 / samples

        winit(image_width, image_height, window_name)

        center          := lookfrom
        h               := tand(vfov / 2)
        viewport_height := 2 * h * focus_dist
        viewport_width  := viewport_height * (image_width / image_height)

        w := unit_vector(vsub(lookfrom, lookat))
        u := unit_vector(cross(vup, w))
        v := cross(w, u)

        viewport_u      := smul(u,          viewport_width)
        viewport_v      := smul(negate(v),  viewport_height)
        pixel_delta_u   := sdiv(viewport_u, image_width)
        pixel_delta_v   := sdiv(viewport_v, image_height)

        viewport_upper_left := vsub(vsub(vsub(center, smul(w, focus_dist)), sdiv(viewport_u, 2)), sdiv(viewport_v, 2))
        pixel00_loc := vadd(viewport_upper_left, smul(vmul(pixel_delta_u, pixel_delta_v), 0.5))
    
        const defocus_radius : real := focus_dist * tand(defocus_angle / 2)
        defocus_disk_u              := smul(u, defocus_radius)
        defocus_disk_v              := smul(v, defocus_radius)
    end initialize

    function sample_square : vec3
	    result vinit(random(-0.5, 0.5), random(-0.5, 0.5), 0)
    end sample_square

    function defocus_disk_sample : vec3
        const p : vec3 := random_in_unit_disk
        result vadd(vadd(center, smul(defocus_disk_u, p.x)), smul(defocus_disk_v, p.y))
    end defocus_disk_sample

    function get_ray(x, y : int) : ray
        var pixel_sample, offset, ray_origin, ray_direction : vec3
        offset          :=  sample_square
        pixel_sample    :=  vadd(pixel00_loc, vadd(smul(pixel_delta_u, x + offset.x), smul(pixel_delta_v, y + offset.y)))
        
        if defocus_angle <= 0 then
            ray_origin := center
        else
            ray_origin := defocus_disk_sample
        end if
        ray_direction  := vsub(pixel_sample, ray_origin)

        result rinit(ray_origin, ray_direction)
    end get_ray

    procedure render(world : ^hittable)
        initialize
        var pixel_color : vec3

        for x : 0 .. image_width
            for y : 0 .. image_height
                pixel_color := vinit(0, 0, 0)
                for sample : 0 .. samples
                    pixel_color := vadd(pixel_color, ray_color(get_ray(x, y), max_depth, world))
                end for
                vSetPixel(x, y, smul(pixel_color, pixel_samples_scale))
            end for
        end for
    end render
end camera
