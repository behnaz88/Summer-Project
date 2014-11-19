function print_equalities(f, Aineq,bineq,Aeq, beq, sostype, sosind, soswt, lb, ub, ctype)
    n = getN(f);

    %print equations
    for i = 1 : 3 * n + 1
        for j = 1 : 9 * n + 1
            if(Aeq(i, j) ~= 0)
                if(Aeq(i, j) == floor(Aeq(i, j)))
                    if(Aeq(i, j) == 1)
                         fprintf('%s + ', get_variable_name(j, n));
                    elseif(Aeq(i, j) == -1)
                         fprintf('-%s + ', get_variable_name(j, n));
                    else
                        fprintf('%d%s + ',Aeq(i,j), get_variable_name(j, n));
                    end
                else
                    fprintf('%.2f%s + ',Aeq(i,j), get_variable_name(j, n));
                end
            end
        end
        fprintf('\b\b = %f\n', beq(i));
    end
    
    
    %print inequations
    for i = 1 : 2 * n
        for j = 1 : 9 * n + 1
            if(Aineq(i, j) ~= 0)
                if(Aineq(i, j) == floor(Aineq(i, j)))
                    if(Aineq(i, j) == 1)
                         fprintf('%s + ', get_variable_name(j, n));
                    elseif(Aineq(i, j) == -1)
                         fprintf('-%s + ', get_variable_name(j, n));
                    else
                        fprintf('%d%s + ',Aineq(i,j), get_variable_name(j, n));
                    end
                else
                    fprintf('%.2f%s + ',Aineq(i,j), get_variable_name(j, n));
                end
            end
        end
        fprintf('\b\b < %f\n', bineq(i));
    end
    
    fprintf('\n\n\n');
        
end