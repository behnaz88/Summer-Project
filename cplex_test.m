function [x, Aeq, beq, Aineq, bineq] = cplex_test(duration, buffer_capacity, x0)

    [f, Aineq,bineq,Aeq, beq, sostype, sosind, soswt, lb, ub, ctype, simulation, mathematical] = matrix_generator_without_ineq(duration, buffer_capacity, x0);
    options = cplexoptimset('TolFun',1e-10,'TolRLPFun',1e-10,'TolXInteger',1e-10);
    x = cplexmilp(f, Aineq,bineq,Aeq, beq, sostype, sosind, soswt, lb, ub, ctype,[],options);
    %x = cplexmilp(f, Aineq,bineq,Aeq, beq, sostype, sosind, soswt, lb, ub, ctype);
    print_equalities(f, Aineq,bineq,Aeq, beq, sostype, sosind, soswt, lb, ub, ctype);
    save_as_gams(f, Aineq,bineq,Aeq, beq, lb, ub, 'test.gms');
%      Y = Aineq *  x;
%      Z = bineq-Y;
%      E = Aeq *  x;
%      F = beq-E;
     sol = reshape(x(2:length(x)),(length(x)-1)/9,9)
     
     s_size = size(simulation, 2);
     m_size = size(mathematical, 2);
     
     for i = 1 : m_size
         fprintf('%f : %f\n', mathematical(i), x(i));
     end
     
    
end