class interval
    export imin, imax, initialize, size, contains, surrounds
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
end interval

function iinit(imin, imax : real) : ^interval
    var i : ^interval
    new i
    i -> initialize(imin, imax)
    result i
end iinit

function iempty : ^interval
    result iinit(+infinity, -infinity)
end iempty

function iuniverse : ^interval
    result iinit(-infinity, +infinity)
end iuniverse
