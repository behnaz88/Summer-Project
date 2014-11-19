function [f, Aineq,bineq,Aeq, beq, sostype, sosind, soswt, lb, ub, ctype] = matrix_generator2(run_duration, buffer_capacity, x0)

%Create Random States
[critical_time, slopes, cop, cop, cop, cop, cop, cop] = Input3(run_duration, 1, 1.2, buffer_capacity);
n = size(slopes, 2);

%Objective Function
f = [zeros(n + 1, 1);ones(4 * n, 1); zeros(2 * n, 1)];

%Equality Matrices
Aeq = zeros(2 * n + 1, 7 * n + 1);
beq = zeros(2 * n + 1, 1);

%Inequality Matrices
Aineq = zeros(2 * n, 7 * n + 1);
bineq = zeros(2 * n, 1);


%lower bounds and upper bounds and other milp matrices
%there is no need for them in this stage
lb = zeros(7 * n + 1, 1);
lb(5 * n + 2 : end) = -inf;
%lb = [];
ub = [];
sostype = [];
sosind = [];
soswt = [];

%Type of variables for Mixed Integer Programming
ctype = zeros(7 * n + 1, 1);

M = 10 ^ 5;  %big constant



%------------------------Equality Matrices---------------------------

%x0 - first row of equality matrix
Aeq(1, 1) = 1;
beq(1, 1) = x0;

for i = 1 : n
    %x(t_{i+1}) = x(t_i) + deltaP_i * u_i
    Aeq(i+1,i+1) = 1; %x(t_{i+1})
    Aeq(i+1,i) = -1;    %x(t_i)
    if(slopes(i) > 0)
        Aeq(i+1, 2 * n + i + 1) = slopes(i);   %deltaP_i * u_i
        %delta f_+ & f_-
        Aeq(n + i + 1, i) = -1/slopes(i);    %1/u_i
        Aeq(n + i + 1,  n + i + 1) = -1;      %deltaF_i+
        Aeq(n + i + 1, 2 * n + i + 1) = 1;       %deltaF_i-
        beq(n + i + 1,1) = critical_time(i+1)-critical_time(i)-(buffer_capacity/slopes(i));       
        beq(i+1,1) = (critical_time(i+1)-critical_time(i)) * slopes(i);
    elseif(slopes(i)<0)
        Aeq(i+1, 4 * n + i + 1) = slopes(i);  %deltaE_i * u_i
        %delta z_+ & z_-
        Aeq(n + i + 1, i) = -1/slopes(i);  %1/u_i
        Aeq(n + i + 1, 3 * n + i + 1) = -1;    %deltaZ_i+
        Aeq(n + i + 1, 4 * n + i + 1) = 1;     %deltaZ_i-
        beq(n + i + 1,1) = critical_time(i+1)-critical_time(i);
        beq(i+1,1) = (critical_time(i+1)-critical_time(i)) * slopes(i);
     elseif(slopes(i)==0)
        Aeq(i+1, 4 * n + i + 1) = 0;  
        Aeq(n + i + 1, i) = 0;  
        Aeq(n + i + 1, 3 * n + i + 1) = 0;    
        Aeq(n + i + 1, 4 * n + i + 1) = 0;     
        beq(n + i + 1,1) = 0;
        beq(i+1,1) = 0;
        
    end
    
end
%Aeq
%beq
critical_time
slopes


%-----------------------Inequality Matrices--------------------------
for i = 1:n
    
    
    if(slopes(i) > 0)
        Aineq(i, n + 1) = 1;
        Aineq(i, 5 * n + 1) = -M;
        
        Aineq(n + i, 2 * n + 1) =1;
        Aineq(n + i, 5 * n + 1) = -M;
    elseif(slopes(i) < 0)
        Aineq(i, 3 * n + 1) = 1;
        Aineq(i, 6 * n + 1) = -M;
        
        Aineq(n + i, 4 * n + 1) =1;
        Aineq(n + i, 6 * n + 1) = -M;
    end
    
    bineq(i) = 0;
    bineq(n + i) = M;
end



%-----------------------Type Matrix------------------------------
ctype(1 : 5 * n + 1) = 'C';    %Continues types of variables
ctype(5 * n + 2 : end) = 'B';      %Binary variables

ctype = ctype';
end