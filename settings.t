var aspect_ratio : real := 16.0 / 9.0
var image_width : int := 400

var image_height : int := image_width div aspect_ratio
if image_height < 1 then
    image_height := 1
end if

var focal_length : real := 1.0
var viewport_height : real := 2.0
var viewport_width : int := floor(viewport_height * (image_width / image_height))
var camera_center : ^vec3 := vinit(0, 0, 0)

var viewport_u : ^vec3 := vinit(viewport_width, 0, 0)
var viewport_v : ^vec3 := vinit(0, -viewport_height, 0)

var pixel_delta_u : ^vec3 := vfdiv(viewport_u, image_width)
var pixel_delta_v : ^vec3 := vfdiv(viewport_v, image_height)

var viewport_upper_left : ^vec3 :=
    vsub(
        vsub(
            vsub(
                camera_center,
                vinit(0, 0, focal_length)
            ),
            vfdiv(viewport_u, 2)
        ),
        vfdiv(viewport_v, 2)
    )

var pixel00_loc : ^vec3 :=
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

var title : string := "Raytracer"
var dimentions : string := intstr(image_width) + ";" + intstr(image_height)

View.Set("graphics:" + dimentions)
View.Set("title:" + title)