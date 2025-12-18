type interval:
    record
        min : real
        max : real
    end record

% Interval initalizer
function iinit(min, max : real) : interval
    var i : interval
    i.min := min
    i.max := max
    result i
end iinit

% Utility functions
function isize(i : interval) : real
    result i.max - i.min
end isize

function icontains(i : interval, x : real) : boolean
    result i.min <= x and x <= i.max
end icontains

function isurrounds(i: interval, x : real) : boolean
    result i.min < x and x < i.max
end isurrounds

function iclamp(i: interval, x : real) : real
    if (x < i.min) then
        result i.min
    elsif (x > i.max) then
        result i.max
    else
        result x
    end if
end iclamp

% Special cases
var iempty : interval := iinit(+infinity, -infinity)
var iuniverse : interval := iinit(-infinity, +infinity)
var iuniversef : interval := iinit(0, infinity)
