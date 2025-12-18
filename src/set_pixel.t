procedure SetPixel(x, y : int, r, g, b : real)
    RGB.SetColor(1, r, g, b)
    drawdot(x, maxy - y, 1)
end SetPixel

procedure vSetPixel(x, y : int, color : vec3)
    var r : real := color.x
    var g : real := color.y
    var b : real := color.z

    var intensity : ^interval := iinit(0.000, 0.999)

    RGB.SetColor(1, intensity -> clamp(r), intensity -> clamp(g), intensity -> clamp(b))
    drawdot(x, maxy - y, 1)

    free intensity
end vSetPixel