function x = cplex_test_b(duration, buffer_capacity, x0)

    [f, Aeq, beq,Aineq,bineq, lb, ub, simulation_results, mathematical_results] = matrix_generator_without_ineq_b(duration, buffer_capacity, x0);
%     fsize = size(f)
%     Aeqsize = size(Aeq)
%     beqsize = size(beq)
%     lbsize = size(lb)
%     ubsize = size(ub)
    x = cplexlp(f,Aineq,bineq,Aeq,beq,lb,ub);
     sol = reshape(x(2:length(x)),(length(x)-1)/7,7)
     b = Aeq*x;
     z = beq-b
    

end