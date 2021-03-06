function [f, Aineq,bineq,Aeq, beq, sostype, sosind, soswt, lb, ub, ctype, simulation_results, mathematical_results] = matrix_generator_without_ineq(run_duration, buffer_capacity, x0)

    %Create Random States
    [critical_time, slopes, cop, cop, machine1, cop, machine2, cop, simulation_results, mathematical_results] = Input1(run_duration, 1.2, 1, buffer_capacity);
    n = size(slopes, 2);

    %Objective Function
    f = [zeros(3 * n + 1, 1);ones(4 * n, 1); zeros(2 * n, 1)];

    %Equality Matrices
    Aeq = zeros(3 * n + 1, 9 * n + 1);
    beq = zeros(3 * n + 1, 1);

    %Inequality Matrices
    Aineq = zeros(2 * n, 9 * n + 1);
    bineq = zeros(2 * n, 1);

    %lower bounds and upper bounds and other milp matrices
    %there is no need for them in this stage
    lb = zeros(9 * n + 1, 1);
    %lb(n + 2 : 3 * n + 1,1) = -inf;
    %lb(7 * n + 2 : end,1) = -inf;
    %lb = [];
    ub = [];
    sostype = [];
    sosind = [];
    soswt = [];

    %Type of variables for Mixed Integer Programming
    ctype = zeros(9 * n + 1, 1);

    M = 10^5;  %big constant
    N = 0;



    %------------------------Equality Matrices---------------------------

    %x0 - first row of equality matrix
    Aeq(1, 1) = 1;
    beq(1, 1) = x0;

    for i = 1 : n
        
        %x(t_{i+1}) = x(t_i) + deltaP_i * u_i
        Aeq(i+1,i) = -1; %x(t_{i+1})
        Aeq(i+1,i+1) = 1;    %x(t_i)
        
        if(slopes(i) > 0)
            Aeq(i+1, 4 * n + i + 1) = slopes(i);   %deltaP_i * u_i
            %delta f_+ & f_-
            Aeq(n + i + 1, i) = -1/slopes(i);    %1/u_i %%%%%
            Aeq(n + i + 1,  3 * n + i + 1) = -1;      %deltaF_i+
            Aeq(n + i + 1, n + i + 1) = 1;       %deltaF
            
            Aeq(2 * n + i + 1, i ) = -1 / slopes(i);   %%%%%%%
            Aeq(2 * n + i + 1, 4 * n + i + 1) = 1;
            Aeq(2 * n + i + 1, 3 * n + i + 1) = -1;
            
            beq(n + i + 1,1) = critical_time(i+1)-critical_time(i)-(buffer_capacity/slopes(i));       
            beq(i+1,1) = (critical_time(i+1)-critical_time(i)) * slopes(i);
            
            beq(2 * n + i + 1, 1) = critical_time(i+1) - critical_time(i) - (buffer_capacity/slopes(i));
            
        elseif(slopes(i)<0)
            
            Aeq(i+1, 6 * n + i + 1 ) = slopes(i);  %deltaE_i * u_i
            %delta z_+ & z_-
            Aeq(n + i + 1, i) = -1/slopes(i);  %1/u_i   %%%%%%%%%
            Aeq(n + i + 1, 5 * n + i + 1) = -1;    %deltaZ_i+
            Aeq(n + i + 1, 2 * n + i + 1) = 1;     %deltaZ
            
            Aeq(2 * n + i + 1, i) = -1 / slopes(i);   %%%%%%%%%
            Aeq(2 * n + i + 1, 6 * n + i + 1) = 1;
            Aeq(2 * n + i + 1, 5 * n + i + 1) = -1;
            
            beq(n + i + 1,1) = critical_time(i+1)-critical_time(i);
            beq(i+1,1) = (critical_time(i+1)-critical_time(i)) * slopes(i);
            
            beq(2 * n + i + 1, 1) = critical_time(i+1) - critical_time(i);
            
         elseif(slopes(i)==0)
             
            Aeq(i+1, 6 * n + i + 1) = 0;  
            Aeq(n + i + 1, i) = 0;  
            Aeq(n + i + 1, 5 * n + i + 1) = 0;    
            Aeq(n + i + 1, 2 * n + i + 1) = 0; 

        end
    end
    %Aeq
    %beq
    %critical_time
    %slopes


    %-----------------------Inequality Matrices--------------------------
    for i = 1:n


        if(slopes(i) > 0)
            
            Aineq(i, 3 * n + i + 1) = 1;
            Aineq(i, 7 * n + i + 1) = -M;

            Aineq(n + i, 4 * n + i + 1) = 1;
            Aineq(n + i, 7 * n + i + 1) = M;
            
            bineq(i) = N;
            bineq(n + i) = M;
            
           
        elseif(slopes(i) < 0)
            
            Aineq(i, 5 * n + i + 1) = 1;
            Aineq(i, 8 * n + i + 1) = -M;

            Aineq(n + i, 6 * n + i + 1) = 1;
            Aineq(n + i, 8 * n + i + 1) = M;
            
            bineq(i) = N;
            bineq(n + i) = M;
        
        elseif(slopes(i) == 0)
            
            Aineq(i, 5 * n + i + 1) = 0;
            Aineq(i, 8 * n + i + 1) = 0;

            Aineq(n + i, 6 * n + i + 1) = 0;
            Aineq(n + i, 8 * n + i + 1) = 0;
            
            bineq(i) = 0;
            bineq(n + i) = 0;
            
            
        end

        
    end



    %-----------------------Type Matrix------------------------------
    ctype(1 : 7 * n + 1) = 'C';    %Continues types of variables
    ctype(7 * n + 2 : end) = 'B';      %Binary variables

    ctype = ctype';
    
    
end