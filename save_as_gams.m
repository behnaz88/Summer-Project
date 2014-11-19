function save_as_gams(f, Aineq,bineq,Aeq, beq, lb, ub, output_file)
n = getN(f);

%open file
fid = fopen(output_file, 'w');




%-----------------Variables--------------
fprintf(fid, 'VARIABLES f;\n');
%positive variables
fprintf(fid, 'POSITIVE VARIABLES ');
for i = 1 : 7 * n
    fprintf(fid, '%s, ', get_variable_name(i, n));
end
fprintf(fid, '%s;\n', get_variable_name(7 * n + 1, n));
%binary variables
fprintf(fid, 'BINARY VARIABLES ');
for i = 7 * n + 2 : 9 * n
    fprintf(fid, '%s, ', get_variable_name(i, n));
end
fprintf(fid, '%s;\n', get_variable_name(9 * n + 1, n));





%---------------Equations Names----------------
fprintf(fid, 'EQUATIONS OBJ, ');
for i = 1 : 3 * n + 1
    fprintf(fid, 'eq%d, ', i);
end
for i = 1 : 2 * n - 1
    fprintf(fid, 'ineq%d, ', i);
end
fprintf(fid, 'ineq%d;\n', 2 * n);




%---------------Equations--------------
%objective
fprintf(fid, 'OBJ.. f =E= ');
for i = 3 * n + 1 : 7 * n
    fprintf(fid, '%s + ', get_variable_name(i, n));
end
fprintf(fid, '%s;\n', get_variable_name(7* n + 1, n));

%constraints
%equations
for i = 1 : 3 * n + 1
    check  = 0;
    fprintf(fid, 'eq%d.. ', i);
    j = 1;
    if(Aeq(i, j) ~= 0)
        check = 1;
        if(Aeq(i, j) == floor(Aeq(i, j)))
            if(Aeq(i, j) == 1)
                fprintf(fid, '%s ', get_variable_name(j, n));
            elseif(Aeq(i, j) == -1)
                fprintf(fid, '-%s ', get_variable_name(j, n));
            else
                fprintf(fid, '%d * %s ',Aeq(i,j), get_variable_name(j, n));
            end
        else
            fprintf(fid, '%f * %s ',Aeq(i,j), get_variable_name(j, n));
        end
    end
    
    for j = 2 : 9 * n + 1
        if(Aeq(i, j) ~= 0)
            check = 1;
            if(Aeq(i, j) == floor(Aeq(i, j)))
                if(Aeq(i, j) == 1)
                    fprintf(fid, '+%s ', get_variable_name(j, n));
                elseif(Aeq(i, j) == -1)
                    fprintf(fid, '-%s ', get_variable_name(j, n));
                elseif(Aeq(i, j) > 0)
                    fprintf(fid, '+%d * %s ',Aeq(i,j), get_variable_name(j, n));
                elseif(Aeq(i, j) < 0)
                    fprintf(fid, '-%d * %s ',abs(Aeq(i,j)), get_variable_name(j, n));
                end
            else
                if(Aeq(i, j) > 0)
                    fprintf(fid, '+%f * %s ',Aeq(i,j), get_variable_name(j, n));
                else
                    fprintf(fid, '-%f * %s ',abs(Aeq(i,j)), get_variable_name(j, n));
                end
            end
        end
    end
    if check == 1
        fprintf(fid, '=E= %f;\n', beq(i));
    else
        fprintf(fid, '0 =L= %f;\n', beq(i));
    end
end

%inequations
for i = 1 : 2 * n
    check = 0;
    fprintf(fid, 'ineq%d.. ', i);
    j = 1;
    if(Aineq(i, j) ~= 0)
        check = 1;
        if(Aineq(i, j) == floor(Aineq(i, j)))
            if(Aineq(i, j) == 1)
                fprintf(fid, '%s ', get_variable_name(j, n));
            elseif(Aineq(i, j) == 1)
                fprintf(fid, '-%s ', get_variable_name(j, n));
            else
                fprintf(fid, '%d * %s ',Aineq(i,j), get_variable_name(j, n));
            end
        else
            fprintf(fid, '%f * %s ',Aineq(i,j), get_variable_name(j, n));
        end
    end
    
    for j = 2 : 9 * n + 1
        if(Aineq(i, j) ~= 0)
            check = 1;
            if(Aineq(i, j) == floor(Aineq(i, j)))
                if(Aineq(i, j) == 1)
                    fprintf(fid, '+%s ', get_variable_name(j, n));
                elseif(Aineq(i, j) == 1)
                    fprintf(fid, '-%s ', get_variable_name(j, n));
                elseif(Aineq(i, j) > 0)
                    fprintf(fid, '+%d * %s ',Aineq(i,j), get_variable_name(j, n));
                elseif(Aineq(i, j) < 0)
                    fprintf(fid, '-%d * %s ',abs(Aineq(i,j)), get_variable_name(j, n));
                end
            else
                if(Aineq(i, j) > 0)
                    fprintf(fid, '+%f * %s ',Aineq(i,j), get_variable_name(j, n));
                else
                    fprintf(fid, '-%f * %s ',abs(Aineq(i,j)), get_variable_name(j, n));
                end
            end
        end
    end
    if check == 1
        fprintf(fid, '=L= %f;\n', bineq(i));
    else
        fprintf(fid, '0 =L= %f;\n', bineq(i));
    end;
end

    
    
    
%-----------------Model----------------
fprintf(fid, 'MODEL inventory /ALL/;\n');




%---------------Solve--------------
fprintf(fid, 'SOLVE inventory USING MIP MINIMIZING f;\n');
end