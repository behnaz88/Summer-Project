function str = get_variable_name(i, n)
    if(i <= n + 1)
        str = sprintf('x%d', i-1);
    elseif(i > n + 1 && i <= 2 * n + 1)
        str = sprintf('Df%d' , i-n-1);
    elseif(i > 2 * n + 1 && i <= 3 * n + 1)
        str = sprintf('Dz%d' , i - (2*n) - 1);
    elseif(i > 3 * n + 1 && i <= 4 * n + 1)
        str = sprintf('Dfp%d' , i - (3*n) - 1);
    elseif(i > 4 * n + 1 && i <= 5 * n + 1)
        str = sprintf('Dfn%d' , i - (4*n) - 1);
    elseif(i > 5 * n + 1 && i <= 6 * n + 1)
        str = sprintf('Dzp%d' , i - (5*n) - 1);
    elseif(i > 6 * n + 1 && i <= 7 * n + 1)
        str = sprintf('Dzn%d' , i - (6*n) - 1);
    elseif(i > 7 * n + 1 && i <= 8 * n + 1)
        str = sprintf('If%d' , i - (7*n) - 1);
    elseif(i > 8 * n + 1 && i <= 9 * n + 1)
        str = sprintf('Iz%d' , i - (8*n) - 1);
    end
end