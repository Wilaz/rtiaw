procedure SetPixel(x, y : int, r, g, b : real)
    RGB.SetColor(1, r, g, b)
    drawdot(x, maxy - y, 1)
end SetPixel

procedure vSetPixel(x, y : int, color : vec3)
    var intensity : interval := iinit(0.000, 0.999)
    RGB.SetColor(1, iclamp(intensity, color.x), iclamp(intensity, color.y), iclamp(intensity, color.z))
    drawdot(x, maxy - y, 1)
end vSetPixel