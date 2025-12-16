class interval
    export imin, imax, initialize, size, contains, surrounds, clamp
    var imin : real
    var imax : real

    procedure initialize(mi, ma : real)
	    imin := mi
	    imax := ma
    end initialize

    function size : real
        result imax - imin
    end size

    function contains(x : real) : boolean
        result imin <= x and x <= imax
    end contains

    function surrounds(x : real) : boolean
        result imin < x and x < imax
    end surrounds

    function clamp(x : real) : real
        if (x < imin) then
            result imin
        elsif (x > imax) then
            result imax
        else
            result x
        end if
    end clamp
end interval

function iinit(imin, imax : real) : ^interval
    var i : ^interval
    new i
    i -> initialize(imin, imax)
    result i
end iinit

var iempty : ^interval := iinit(+infinity, -infinity)
var iuniverse : ^interval := iinit(-infinity, +infinity)
var iuniversef : ^interval := iinit(0, infinity)