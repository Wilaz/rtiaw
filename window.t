procedure winit(width, height : int, title : string)
    var dimentions : string := intstr(width) + ";" + intstr(height)

    View.Set("graphics:" + dimentions)
    View.Set("title:" + title)
end winit