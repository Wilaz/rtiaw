procedure winit(width, height : int, title : string)
    View.Set("graphics:" + intstr(width) + ";" + intstr(height))
    View.Set("title:" + title)
end winit