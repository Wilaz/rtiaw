procedure SetPixel(x, y : int, r, g, b : real)
    RGB.SetColor(1, r, g, b)
    drawdot(x, maxy - y, 1)
end SetPixel

procedure vSetPixel(x, y : int, color : ^vec3)
    RGB.SetColor(1, color -> x, color -> y, color -> z)
    drawdot(x, maxy - y, 1)
end vSetPixel