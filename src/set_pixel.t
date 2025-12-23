function linear_to_gamma(linear_component : real) : real
    if linear_component > 0.0 then
        result sqrt(linear_component)
    else
        result 0.0
    end if
end linear_to_gamma

procedure vSetPixel(x, y : int, color : vec3)
    var intensity : interval := iinit(0.000, 0.999)
    RGB.SetColor(1, iclamp(intensity, linear_to_gamma(color.x)), iclamp(intensity, linear_to_gamma(color.y)), iclamp(intensity, linear_to_gamma(color.z)))
    drawdot(x, maxy - y, 1)
end vSetPixel