function enable_flag(_f1,_f2)
    if (_f1 & _f2 == 0) then
        _f1 = _f1 | _f2
    end
    
    return _f1
end

function disable_flag(_f1,_f2)
    if (_f1 & _f2 == _f2) then
        _f1 = _f1 ~ _f2
    end
    
    return _f1
end