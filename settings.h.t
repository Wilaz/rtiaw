var image_width : int
var image_height : int
var aspect_ratio : real

var focal_length : real
var viewport_height : real
var camera_center : ^point3

var title : string

function dimentions : string
    result intstr(width) + ";" + intstr(height)
end dimentions

function viewport_width : int
    result round( viewport_height * (image_width / image_height) )
end dimentions