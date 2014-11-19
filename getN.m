function n = getN(in)
    x = size(in, 1);
    y = size(in, 2);
    
    % make a difference
    if x > y
        m = x;
    else
        m = y;
    end
    
    n = (m - 1) / 9;
end